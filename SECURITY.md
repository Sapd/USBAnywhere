# 🛡️ Security Policy — USBAnywhere

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 3.0.x   | :white_check_mark: |
| < 3.0   | :x: (Upgrade to USBAnywhere v3.0.0) |

## Security Architecture & Hardening

**USBAnywhere** is designed with a strict Zero-Trust security model:

1. **Command & Argument Injection Prevention (`InputValidator`)**
   - All IPv4 addresses, hostnames, USB `bus-id` identifiers, and SSH usernames are strictly validated via whitelist regular expressions before any process invocation.
   - All external processes (`usbipw.exe`, `devnode.exe`, `pnputil.exe`) are executed with `UseShellExecute = false` and explicit argument arrays where applicable.
2. **Cryptographic Integrity Verification (Fail-Closed)**
   - **In-App Auto-Updater (`UpdateService`)**: Enforces HTTPS host whitelisting (`github.com`, `objects.githubusercontent.com`) and mandatory **SHA-256** verification against `SHA256SUMS.txt` before executing any update package.
   - **Virtual PnP Node Manager (`DriverService`)**: Verifies the exact SHA-256 digest of `devnode.exe` before invoking UDE driver installation.
3. **Microsoft WHQL-Certified Drivers**
   - Uses Microsoft WHQL-signed `usbip2_ude.sys` and `usbip2_filter.sys` drivers, fully compatible with Windows 10/11 **Core Isolation / Memory Integrity (HVCI)** without requiring Windows Test Mode on x64 systems.

## Reporting a Vulnerability

If you discover a security issue, please open a [GitHub Security Advisory](https://github.com/oscarlosu-lab/USBAnywhere/security/advisories/new) or report it via [GitHub Issues](https://github.com/oscarlosu-lab/USBAnywhere/issues).
