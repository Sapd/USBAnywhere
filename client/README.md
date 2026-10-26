# 🖥️ USBAnywhere Client (Windows WPF)

🌐 **Language / Idioma:** **English** | [Español](README_ES.md)

**USBAnywhere Client** is a high-performance Windows desktop client designed to discover, attach, and manage remote USB devices shared over the network via the USB/IP protocol.

[![License](https://img.shields.io/badge/License-GPLv3-blue.svg?style=flat-square)](https://www.gnu.org/licenses/gpl-3.0)
[![Platform](https://img.shields.io/badge/platform-Windows%2010%2F11%20(x64%20%7C%20ARM64)-lightgrey?style=flat-square&logo=windows)](https://github.com/oscarlosu-lab/USBAnywhere)
[![.NET](https://img.shields.io/badge/.NET-9.0-purple?style=flat-square&logo=dotnet)](https://dotnet.microsoft.com/)
[![Ko-fi](https://img.shields.io/badge/Ko--fi-Support%20Project-FF5E5B?style=flat-square&logo=ko-fi&logoColor=white)](https://ko-fi.com/oscarlosu)

---

## 🏗️ Architecture & Component Overview

```text
client/
├── src/
│   └── USBAnywhere/
│       ├── Views/              # WPF XAML Windows & Controls
│       ├── ViewModels/         # MVVM Presentation Logic
│       ├── Services/           # Core System & Hardware Services
│       │   ├── DriverService.cs         # UDE PnP Driver Lifecycle & WHQL Node Manager
│       │   ├── UsbIpService.cs          # usbip CLI Orchestrator & Device Parser
│       │   ├── ConfigService.cs         # Atomic JSON Configuration Persistence
│       │   ├── DeviceMonitorService.cs  # Real-Time PnP & Connection Watchdog
│       │   ├── UpdateService.cs         # Fail-Closed SHA-256 Verified Auto-Updater
│       │   ├── LocalizationService.cs   # Dynamic Runtime i18n (EN/ES)
│       │   └── LoggerService.cs         # Rotating File & Diagnostic Diagnostics
│       └── Security/
│           ├── InputValidator.cs        # Strict Whitelist Regex Sanitization
│           └── SignatureVerifier.cs     # Authenticode Digital Signature Validation
├── tests/
│   └── USBAnywhere.Tests/      # 74 xUnit Zero-Trust Unit & Integration Tests
├── Portable/                   # x64 Distributed Binaries & WHQL Drivers
├── Portable-ARM64/             # ARM64 Native Binaries
├── installer/                  # Inno Setup Script (USBAnywhere_Setup.iss)
└── Publish-Release.ps1         # Automated Multi-Arch Release Packaging Script
```

---

## ⚡ Key Capabilities

- **Kernel-Level Low Latency (`--receive-mode low-latency`)**:
  Leverages Windows Kernel WSK (Winsock Kernel) callbacks for millisecond response times, making it ideal for SimRacing wheels, flight joysticks, gamepads, and VR trackers.
- **High-Throughput Zero-Copy (`--receive-mode zero-copy`)**:
  Optimized kernel buffers for bulk data streams like flash drives, SSDs, 3D printers, laser engravers, and webcams.
- **WHQL-Certified Driver Stack**:
  Uses signed `usbip2_ude.sys` and `usbip2_filter.sys` drivers fully compatible with **Core Isolation / Memory Integrity (HVCI)** on Windows 10 & 11.
- **Graceful Shutdown Detach**:
  Asynchronously decouples all active remote USB ports on window close or Alt+F4 to prevent busy port locks on remote servers.
- **Zero-Trust Hardening**:
  Whitelisted argument validation, strict Authenticode signature checking on executables, and fail-closed SHA-256 verification on updates.

---

## 🛠️ Building & Testing

### Prerequisites
- Windows 10/11 (x64 or ARM64)
- .NET 9.0 SDK (`dotnet --version`)
- Visual Studio 2022 or VS Code with C# Dev Kit

### Compilation Commands
```powershell
# Restore NuGet dependencies
dotnet restore USBAnywhere.sln

# Build Release
dotnet build USBAnywhere.sln -c Release --no-restore

# Run all 74 unit tests
dotnet test USBAnywhere.sln -c Release --no-build --verbosity normal
```

### Packaging Release Artifacts
To generate the Inno Setup installer, standalone portable ZIPs (x64 and ARM64), and SHA256 checksums:
```powershell
.\client\Publish-Release.ps1 -Version "3.0.1"
```

---

## 📄 License

GPL-3.0 License. Developed by [oscarlosu-lab](https://github.com/oscarlosu-lab).
