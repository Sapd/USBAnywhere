# ⚡ USBAnywhere Automation & Setup Scripts

🌐 **Language / Idioma:** **English** | [Español](README_ES.md)

This directory contains provisioning scripts and media automation tools for the USBAnywhere ecosystem.

[![License](https://img.shields.io/badge/License-GPLv3-blue.svg?style=flat-square)](https://www.gnu.org/licenses/gpl-3.0)
[![Ko-fi](https://img.shields.io/badge/Ko--fi-Support%20Project-FF5E5B?style=flat-square&logo=ko-fi&logoColor=white)](https://ko-fi.com/oscarlosu)

---

## 📜 Script Index

### 1. `install-server.sh` — 1-Click Linux / Raspberry Pi Server Installer
Automated shell installer for Linux and Raspberry Pi OS (Debian/Ubuntu/Raspbian/Arch/Fedora).
- Automatically loads `usbip_core` and `usbip_host` kernel modules.
- Installs `usbip` userspace package.
- Creates `/etc/systemd/system/usbipd.service` to run on boot.
- Installs udev hotplug rule `/etc/udev/rules.d/99-usbip-autobind.rules` to auto-export any peripheral plugged into the host.

**1-Click Command**:
```bash
curl -fsSL https://raw.githubusercontent.com/oscarlosu-lab/USBAnywhere/main/scripts/install-server.sh | sudo bash
```

### 2. Media & Video Generators
Python automation utilities using MoviePy, Pillow, and ElevenLabs API for generating tutorials and visual walkthroughs:
- `generate_laser_lightburn_video.py` — Generates high-resolution LightBurn laser engraver setup tutorials.
- `generate_masterclass_video.py` — Produces the SimRacing / Flight Sim masterclass video.
- `generate_thumbnails.py` & `generate_laser_thumbnails.py` — Produces YouTube thumbnail assets.

---

## 📄 License

GPL-3.0 License. Developed by [oscarlosu-lab](https://github.com/oscarlosu-lab).
