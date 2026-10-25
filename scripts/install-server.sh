#!/usr/bin/env bash
# ==============================================================================
# 🌐 USBAnywhere — 1-Click Linux & Raspberry Pi Plug & Play Server Installer
# https://github.com/oscarlosu-lab/USBAnywhere
#
# Usage:
#   curl -sSL https://raw.githubusercontent.com/oscarlosu-lab/USBAnywhere/main/scripts/install-server.sh | sudo bash
#
# Features:
#   1. Installs usbip, hwdata, and usbutils across Debian/Ubuntu/PiOS/Fedora/Arch
#   2. Loads usbip_core & usbip_host kernel modules persistently across reboots
#   3. Creates a systemd service (usbanywhere-server.service) running usbipd
#   4. Sets up a udev rule + auto-bind helper so any USB device plugged into the
#      server is automatically exported to Windows (100% Plug & Play like VirtualHere!)
# ==============================================================================

set -e

echo "================================================================"
echo " 🌐 USBAnywhere Server Installer (Plug & Play Edition)"
echo "================================================================"

if [ "$EUID" -ne 0 ]; then
    echo "❌ Please run as root (use sudo)."
    exit 1
fi

# 1. Detect Package Manager & Install Dependencies
echo "[1/4] Installing USB/IP packages..."
if command -v apt-get >/dev/null 2>&1; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -qq
    # Try standard Debian/Armbian/Raspbian 'usbip' package first; fallback to Ubuntu 'linux-tools'
    if ! apt-get install -y usbip hwdata usbutils 2>/dev/null; then
        apt-get install -y "linux-tools-$(uname -r)" hwdata usbutils 2>/dev/null || \
        apt-get install -y linux-tools-generic linux-tools-common hwdata usbutils
    fi
elif command -v dnf >/dev/null 2>&1; then
    dnf install -y usbip hwdata usbutils
elif command -v pacman >/dev/null 2>&1; then
    pacman -Sy --noconfirm usbip hwdata usbutils
elif command -v opkg >/dev/null 2>&1; then
    opkg update && opkg install usbip-server kmod-usb-ohci usbutils
else
    echo "⚠️ Unsupported package manager. Ensure 'usbip' and 'usbipd' are installed."
fi

# On Ubuntu with custom SBC kernels (Armbian/OrangePi/RPi), /usr/bin/usbip wrapper may fail
# looking for /usr/lib/linux-tools/$(uname -r)/usbip. Link the actual binary if needed.
if ! usbip version >/dev/null 2>&1; then
    REAL_USBIP=$(find /usr/lib/linux-tools -name usbip -type f -executable 2>/dev/null | tail -n 1 || true)
    REAL_USBIPD=$(find /usr/lib/linux-tools -name usbipd -type f -executable 2>/dev/null | tail -n 1 || true)
    if [ -n "$REAL_USBIP" ] && [ -n "$REAL_USBIPD" ]; then
        mkdir -p /usr/local/sbin
        ln -sf "$REAL_USBIP" /usr/local/sbin/usbip
        ln -sf "$REAL_USBIPD" /usr/local/sbin/usbipd
    fi
fi

# 2. Load Kernel Modules Persistently
echo "[2/4] Enabling kernel modules (usbip_core, usbip_host)..."
modprobe usbip-core 2>/dev/null || modprobe usbip_core 2>/dev/null || true
if ! modprobe usbip_host 2>/dev/null && [ ! -d /sys/bus/usb/drivers/usbip-host ]; then
    echo "⚠️ Warning: Could not load 'usbip_host' for running kernel $(uname -r)."
    if [ ! -d "/lib/modules/$(uname -r)" ]; then
        echo "   Kernel was updated on disk. Please run 'sudo reboot' after this script finishes."
    fi
fi

mkdir -p /etc/modules-load.d
cat << 'EOF' > /etc/modules-load.d/usbanywhere.conf
usbip-core
usbip_host
EOF

# 3. Create Auto-Bind Helper Script (Excludes USB Hubs, Root Disk & Network Adapters)
echo "[3/4] Installing Plug & Play Auto-Bind script..."
cat << 'EOF' > /usr/local/bin/usbanywhere-autobind.sh
#!/usr/bin/env bash
# Auto-binds all external USB devices while safely skipping root hubs, root/boot disk, and NICs
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

USBIP_BIN=$(command -v usbip || echo "/usr/sbin/usbip")
LOCK_FILE="/run/usbanywhere-autobind.lock"

bind_all_usb() {
    (
        flock -w 5 9 || exit 0

        local root_src root_disks=""
        root_src=$(findmnt -n -o SOURCE / 2>/dev/null || true)
        if [[ -n "$root_src" && -b "$root_src" ]]; then
            root_disks=$(lsblk -no PKNAME "$root_src" 2>/dev/null | sort -u | tr '\n' ' ')
        fi

        for devpath in /sys/bus/usb/devices/*; do
            [ -e "$devpath" ] || continue
            busid=$(basename "$devpath")
            # Skip interfaces (containing ':') and root usb buses ('usb1', 'usb2', etc.)
            [[ "$busid" == *:* ]] && continue
            [[ "$busid" == usb* ]] && continue
            [[ ! -f "$devpath/idVendor" ]] && continue

            bDeviceClass=$(cat "$devpath/bDeviceClass" 2>/dev/null || echo "")
            idVendor=$(cat "$devpath/idVendor" 2>/dev/null || echo "")
            idProduct=$(cat "$devpath/idProduct" 2>/dev/null || echo "")

            # Skip USB Hubs (Class 09)
            [[ "$bDeviceClass" == "09" ]] && continue

            # Skip Raspberry Pi onboard SMSC/Microchip USB Ethernet bridges
            [[ "$idVendor:$idProduct" == "0424:ec00" ]] && continue
            [[ "$idVendor:$idProduct" == "0424:7800" ]] && continue

            # Skip USB network adapters (Ethernet / Wi-Fi dongles) to prevent losing SSH connectivity
            if ls "$devpath"/*/net/* >/dev/null 2>&1; then
                continue
            fi

            # Skip ONLY USB storage devices that back the running root (/) filesystem
            skip_root=0
            for blk in "$devpath"/*/host*/target*/*/block/* "$devpath"/*/block/*; do
                [ -e "$blk" ] || continue
                blkname=$(basename "$blk")
                if [[ -n "$root_disks" && " $root_disks " == *" $blkname "* ]]; then
                    skip_root=1
                    break
                fi
            done
            [[ "$skip_root" -eq 1 ]] && continue

            # Bind device if not already bound to usbip-host, or recover if in error state (3)
            driver_link=$(readlink "$devpath/driver" 2>/dev/null || echo "")
            if [[ "$driver_link" != *"usbip-host"* ]]; then
                if [[ -z "$driver_link" ]]; then
                    echo -n "$busid" > /sys/bus/usb/drivers/usb/bind 2>/dev/null || true
                fi
                if ! "$USBIP_BIN" bind -b "$busid" >/dev/null 2>&1; then
                    echo -n "del $busid" > /sys/bus/usb/drivers/usbip-host/match_busid 2>/dev/null || true
                    echo -n "$busid" > /sys/bus/usb/drivers/usb/bind 2>/dev/null || true
                    "$USBIP_BIN" bind -b "$busid" >/dev/null 2>&1 || true
                fi
            else
                status=$(cat "$devpath/usbip_status" 2>/dev/null || echo "1")
                if [[ "$status" == "3" ]]; then
                    "$USBIP_BIN" unbind -b "$busid" >/dev/null 2>&1 || true
                    echo -n "$busid" > /sys/bus/usb/drivers/usb/bind 2>/dev/null || true
                    "$USBIP_BIN" bind -b "$busid" >/dev/null 2>&1 || true
                fi
            fi
        done
    ) 9>"$LOCK_FILE"
}

if [[ "${1:-}" == "--watch" ]]; then
    while true; do
        bind_all_usb
        sleep 2
    done
else
    bind_all_usb
fi
EOF
chmod +x /usr/local/bin/usbanywhere-autobind.sh

# 4. Configure systemd services & udev hotplug rule
echo "[4/4] Configuring systemd daemons and udev hotplug rules..."
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"
if command -v systemctl >/dev/null 2>&1; then
    USBIPD_BIN=$(command -v usbipd || echo "/usr/sbin/usbipd")
    cat << EOF > /etc/systemd/system/usbanywhere.service
[Unit]
Description=USBAnywhere USB/IP Server Daemon
After=network.target

[Service]
Type=forking
ExecStart=${USBIPD_BIN} -D
Restart=always
RestartSec=2

[Install]
WantedBy=multi-user.target
EOF

    cat << 'EOF' > /etc/systemd/system/usbanywhere-autobind.service
[Unit]
Description=USBAnywhere Plug & Play USB Auto-Bind Watcher
After=usbanywhere.service
Requires=usbanywhere.service

[Service]
Type=simple
ExecStart=/usr/local/bin/usbanywhere-autobind.sh --watch
Restart=always
RestartSec=2

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable usbanywhere.service usbanywhere-autobind.service
    systemctl restart usbanywhere.service || true
    systemctl restart usbanywhere-autobind.service || true
else
    usbipd -D || true
    nohup /usr/local/bin/usbanywhere-autobind.sh --watch >/dev/null 2>&1 &
fi

if [ -d /etc/udev/rules.d ]; then
    cat << 'EOF' > /etc/udev/rules.d/99-usbanywhere-autobind.rules
ACTION=="add", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", RUN+="/bin/sh -c 'systemd-run --no-block /usr/local/bin/usbanywhere-autobind.sh || /usr/local/bin/usbanywhere-autobind.sh'"
EOF
    udevadm control --reload-rules 2>/dev/null || true
fi

IP_ADDR=$(hostname -I 2>/dev/null | awk '{print $1}')
echo ""
echo "✅ USBAnywhere Server is active and running on port 3240!"
echo "📡 Server IP: ${IP_ADDR:-<your-server-ip>}"
echo "🔌 Plug & Play Auto-Export is ENABLED: any USB device plugged in is shared automatically."
echo "----------------------------------------------------------------"
usbip list -l 2>/dev/null || true
echo "================================================================"
