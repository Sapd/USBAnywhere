# ⚡ USBAnywhere Automation & Setup Scripts

🌐 **Language / Idioma:** **English** | [Español](README_ES.md)

This directory contains provisioning scripts, control suites, and media automation tools for the USBAnywhere ecosystem.

[![License](https://img.shields.io/badge/License-GPLv3-blue.svg?style=flat-square)](https://www.gnu.org/licenses/gpl-3.0)
[![Ko-fi](https://img.shields.io/badge/Ko--fi-Support%20Project-FF5E5B?style=flat-square&logo=ko-fi&logoColor=white)](https://ko-fi.com/oscarlosu)

---

## 📜 Script Index

### 1. `usbanywhere-ctl` — Unified Control Suite (macOS & Linux)
Interactive Terminal User Interface (TUI) dashboard and CLI management tool with zero external dependencies.
- **Interactive TUI Dashboard**: `usbanywhere-ctl` (or `usbanywhere-ctl dashboard`)
- **System Doctor**: `usbanywhere-ctl doctor`
- **Protocol Loopback Test**: `usbanywhere-ctl test`
- **Service Control**: `sudo usbanywhere-ctl start|stop|restart|status`
- **Device Management**: `usbanywhere-ctl list`, `sudo usbanywhere-ctl share <busid>`

### 2. Native macOS installation

For normal use, drag USBAnywhere.app into Applications, open it and complete setup.
The Swift app/service need no Python installation. The optional shared CLI requires
Python 3 and is installed with the helper.

This checkout's `install-server-mac.sh`, `uninstall-server-mac.sh` and
`usbanywhere-ctl` delegate to `server-windows/scripts/`. Initialize that submodule;
it is the single source for desktop-server implementation and installation.

```sh
git submodule update --init server-windows
server-windows/src/USBAnywhere.Server.Mac/build.sh
sudo sh scripts/install-server-mac.sh MAC_IPV4 WINDOWS_IPV4
python3 scripts/usbanywhere-ctl status --json
```

Choose devices in the app. CLI `share`, `unshare` and `reconnect` use remembered
bus IDs and the same native authorization; only service lifecycle commands need
sudo. On Mac, `test` is a local-control health check. Network USB/IP testing must
run from an allowed client. See the [Mac guide](../server-windows/src/USBAnywhere.Server.Mac/README.md).

### 3. `install-server-linux.sh` / `install-server.sh` — 1-Click Linux / Raspberry Pi Installer
Automated installer for Linux distributions and Raspberry Pi OS (Debian/Ubuntu/Raspbian/Arch/Fedora).
- Automatically loads `usbip_core` and `usbip_host` kernel modules.
- Installs `usbip` userspace package and systemd daemon.
- Configures udev hotplug auto-exporting rule.
- Installs `usbanywhere-ctl` to `/usr/local/bin/`.

```bash
curl -fsSL https://raw.githubusercontent.com/oscarlosu-lab/USBAnywhere-Server/main/scripts/install-server-linux.sh | sudo bash
```

### 4. Media & Video Generators
Python automation utilities using MoviePy, Pillow, and ElevenLabs API for generating tutorials and visual walkthroughs:
- `generate_laser_lightburn_video.py` — Generates high-resolution LightBurn laser engraver setup tutorials.
- `generate_masterclass_video.py` — Produces the SimRacing / Flight Sim masterclass video.
- `generate_thumbnails.py` & `generate_laser_thumbnails.py` — Produces YouTube thumbnail assets.

---

## 📄 License

GPL-3.0 License. Developed by [oscarlosu-lab](https://github.com/oscarlosu-lab).
