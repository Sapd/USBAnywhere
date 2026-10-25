FROM debian:bookworm-slim

LABEL org.opencontainers.image.title="USBAnywhere Server"
LABEL org.opencontainers.image.description="Lightweight Plug & Play USB/IP Server for HomeLab, Unraid, TrueNAS & Proxmox"
LABEL org.opencontainers.image.url="https://github.com/oscarlosu-lab/USBAnywhere"
LABEL org.opencontainers.image.licenses="GPL-3.0"

RUN apt-get update && \
    apt-get install -y --no-install-recommends usbip hwdata usbutils kmod ca-certificates && \
    rm -rf /var/lib/apt/lists/*

COPY ../scripts/install-server.sh /usr/local/bin/install-server.sh

EXPOSE 3240/tcp

CMD ["sh", "-c", "modprobe usbip_host 2>/dev/null || true; usbipd -D && while true; do for d in /sys/bus/usb/devices/*; do b=$(basename \"$d\"); case \"$b\" in *:*) continue;; usb*) continue;; esac; [ ! -f \"$d/idVendor\" ] && continue; [ \"$(cat \"$d/bDeviceClass\" 2>/dev/null)\" = \"09\" ] && continue; usbip bind -b \"$b\" >/dev/null 2>&1 || true; done; sleep 5; done"]
