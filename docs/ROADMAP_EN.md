# 🗺️ Technical & Future Roadmap — USBAnywhere

🌐 **Language / Idioma:** **English** | [Español](ROADMAP_MEJORAS.md)

This document tracks completed engineering milestones, architectural optimizations, and planned features across the entire **USBAnywhere** ecosystem (Windows Client, Windows Server, macOS Server, Linux Server, and Android Server).

[![License](https://img.shields.io/badge/License-GPLv3-blue.svg?style=flat-square)](https://www.gnu.org/licenses/gpl-3.0)
[![Ko-fi](https://img.shields.io/badge/Ko--fi-Support%20Project-FF5E5B?style=flat-square&logo=ko-fi&logoColor=white)](https://ko-fi.com/oscarlosu)

---

## ⚡ 1. Performance & USB/IP Protocol

| Enhancement | Impact | Status | Technical Description |
|---|---|---|---|
| **Receive Mode Selection (`--receive-mode`)** | **High** | ✅ **v3.0.0** | Toggle between `zero-copy` (maximum throughput for flash drives, SSDs, and webcams) and `low-latency` (WSK kernel callbacks for SimRacing wheels, HOTAS, and gamepads). |
| **Graceful Shutdown Detach** | **High** | ✅ **v3.0.1** | Clean asynchronous unbinding of all active remote USB ports on Alt+F4 or window exit, preventing "device busy" lockups on remote hosts. |
| **Driver & Binary Integrity Verification** | **High** | ✅ **v3.0.1** | Synchronized SHA-256 digest validation for `usbipw.exe` and Authenticode digital signature enforcement on all distributed binaries. |
| **Traffic Compression for Slow Networks (WAN/VPN)** | **Medium** | ⏳ **Planned v3.1** | Optional LZ4 or Zstandard compression over TCP tunnels for bandwidth-constrained connections (useful on Tailscale and 4G/5G mobile setups). |
| **Ultra-Low Latency UDP / WebRTC Transport** | **Research** | 🔬 **R&D** | Exploring UDP tunnels with selective retransmission for high-polling rate HID peripherals (1000 Hz / 8000 Hz). |

---

## 🛡️ 2. Multiplatform Server Ecosystem

| Component / Server | Platform | Status | Technical Description |
|---|---|---|---|
| **Native macOS Server** | 🍎 macOS (Apple Silicon M1-M4 & Intel) | ✅ **v3.0.1** | Native Swift 5.9+ server utilizing Userspace IOKit (`IOUSBHostInterface`). No kernel extensions (`.kext`) and no SIP bypass required. Managed via `launchd` system daemon with a 1-click terminal installer. |
| **Desktop Windows Server** | 🖥️ Windows 10/11 (x64) | ✅ **v3.0.1** | Modern .NET 9.0 desktop GUI server with system tray integration, persistent auto-bind, and firewall rules scoped strictly to private networks. |
| **Linux / Raspberry Pi Server** | 🐧 Linux / RPi OS | ✅ **v3.0.0** | 1-Click `install-server.sh` installer with `systemd` daemon management and `udev` hotplug auto-exporting rules. |
| **Android Server** | 📱 Android 10+ (TV / Mobile) | ✅ **v3.0.0** | Rootless USB/IP server for Android and Android TV with Sunshine / Moonlight integration and DualSense haptics support. |

---

## 💻 3. User Interface & Experience (WPF / UI)

| Enhancement | Impact | Status | Technical Description |
|---|---|---|---|
| **Visual Latency Mode Selector** | **High** | ✅ **v3.0.0** | Interactive bottom status bar toggle (`⚡ Mode: Zero-Copy` / `🏎️ Mode: Low-Latency`) with instant persistence in `config.json`. |
| **Transparent Network Diagnostics** | **High** | ✅ **v3.0.1** | Clear, transparent UI feedback when remote USB/IP servers (port 3240) are unreachable, replacing silent timeouts. |
| **Real-Time Ping Latency (`[ms]`)** | **High** | ✅ **v3.0.0** | Live TCP ping measurement (`[2ms]`) displayed alongside each discovered server in the device tree. |
| **Dynamic Themes (Dark / Light) & i18n** | **Medium** | ✅ **v3.0.0** | Runtime dynamic switching between Dark/Light modes and English/Spanish languages via `DynamicResource`. |
| **Profile & Favorite Export / Import** | **Low** | ⏳ **Planned v3.1** | Ability to export and import server lists and favorite peripherals as JSON for multi-workstation deployments. |

---

## 🧪 4. Quality Assurance, Testing & CI/CD

| Verification Suite | Platform | Status | Coverage |
|---|---|---|---|
| **Client Unit Tests** | Windows runner | ✅ **74 Tests** | `usb.ids` hex normalization, `InputValidator`, `ConfigService`, `SignatureVerifier`, and driver lifecycle. |
| **Windows Server Unit Tests** | Windows runner | ✅ **54 Tests** | Data models, configuration persistence, PnP orchestrator, and network validation. |
| **macOS Server Unit Tests** | macOS Apple Silicon runner | ✅ **5 Tests** | Big-endian serialization, URB packet encoding, and device structures. |
| **macOS Live TCP Integration Test** | macOS Apple Silicon runner | ✅ **Active in CI** | Boots the daemon in macOS runner, invokes IOKit `list`, and validates binary TCP handshake on port 3240. |
| **Multi-Arch Packaging** | Windows (x64 & ARM64) | ✅ **v3.0.1** | Distinct native x64 and ARM64 packages with corresponding Scoop bucket and WinGet manifests. |

---

## 📄 License

GPL-3.0 License. Developed by [oscarlosu-lab](https://github.com/oscarlosu-lab).
