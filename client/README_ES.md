# 🖥️ Cliente USBAnywhere (Windows WPF)

🌐 **Idioma / Language:** [English](README.md) | **Español**

**USBAnywhere Client** es un cliente de escritorio de alto rendimiento para Windows diseñado para descubrir, conectar y gestionar dispositivos USB remotos compartidos a través de la red mediante el protocolo USB/IP.

[![Licencia](https://img.shields.io/badge/Licencia-GPLv3-blue.svg?style=flat-square)](https://www.gnu.org/licenses/gpl-3.0)
[![Plataforma](https://img.shields.io/badge/plataforma-Windows%2010%2F11%20(x64%20%7C%20ARM64)-lightgrey?style=flat-square&logo=windows)](https://github.com/oscarlosu-lab/USBAnywhere)
[![.NET](https://img.shields.io/badge/.NET-9.0-purple?style=flat-square&logo=dotnet)](https://dotnet.microsoft.com/)
[![Ko-fi](https://img.shields.io/badge/Ko--fi-Apoyar%20Proyecto-FF5E5B?style=flat-square&logo=ko-fi&logoColor=white)](https://ko-fi.com/oscarlosu)

---

## 🏗️ Arquitectura y Estructura del Proyecto

```text
client/
├── src/
│   └── USBAnywhere/
│       ├── Views/              # Vistas XAML de WPF y controles de interfaz
│       ├── ViewModels/         # Lógica de presentación MVVM
│       ├── Services/           # Servicios centrales del sistema y hardware
│       │   ├── DriverService.cs         # Ciclo de vida de controladores UDE PnP y WHQL
│       │   ├── UsbIpService.cs          # Orquestador del CLI usbip y parseador de dispositivos
│       │   ├── ConfigService.cs         # Persistencia atómica de configuración JSON
│       │   ├── DeviceMonitorService.cs  # Monitor PnP en tiempo real y watchdog de conexión
│       │   ├── UpdateService.cs         # Auto-actualizador seguro con verificación SHA-256
│       │   ├── LocalizationService.cs   # Internacionalización dinámica en caliente (EN/ES)
│       │   └── LoggerService.cs         # Registro de diagnósticos y rotación de logs
│       └── Security/
│           ├── InputValidator.cs        # Sanitización estricta por lista blanca (Regex)
│           └── SignatureVerifier.cs     # Validación de firmas digitales Authenticode
├── tests/
│   └── USBAnywhere.Tests/      # Suite de 74 tests unitarios y de integración Zero-Trust
├── Portable/                   # Binarios x64 distribuidos y drivers WHQL
├── Portable-ARM64/             # Binarios nativos ARM64
├── installer/                  # Script Inno Setup (USBAnywhere_Setup.iss)
└── Publish-Release.ps1         # Script de empaquetado multi-arquitectura automatizado
```

---

## ⚡ Capacidades Principales

- **Baja Latencia a Nivel de Kernel (`--receive-mode low-latency`)**:
  Utiliza callbacks WSK (*Winsock Kernel*) en el controlador para tiempos de respuesta de milisegundos, ideal para volantes de SimRacing, mandos de vuelo (HOTAS), gamepads y sensores VR.
- **Máximo Rendimiento Zero-Copy (`--receive-mode zero-copy`)**:
  Búferes de kernel optimizados para transferencias masivas de datos: memorias USB, discos SSD, impresoras 3D, grabadoras láser y cámaras web.
- **Controladores con Certificación WHQL**:
  Incluye drivers firmados `usbip2_ude.sys` y `usbip2_filter.sys` totalmente compatibles con **Aislamiento del núcleo / Integridad de memoria (HVCI)** en Windows 10 y 11.
- **Desconexión Limpia al Salir (Graceful Shutdown)**:
  Libera y desacopla de forma asíncrona todos los puertos USB remotos al cerrar la ventana o pulsar Alt+F4, evitando que los servidores remotos queden en estado ocupado (*busy*).
- **Seguridad Zero-Trust Reforzada**:
  Validación estricta de argumentos, verificación de firmas Authenticode en ejecutables y comprobación criptográfica SHA-256 en actualizaciones.

---

## 🛠️ Compilación y Pruebas

### Requisitos Previos
- Windows 10 u 11 (x64 o ARM64)
- .NET 9.0 SDK (`dotnet --version`)
- Visual Studio 2022 o VS Code con C# Dev Kit

### Comandos de Compilación
```powershell
# Restaurar dependencias NuGet
dotnet restore USBAnywhere.sln

# Compilar en modo Release
dotnet build USBAnywhere.sln -c Release --no-restore

# Ejecutar los 74 tests unitarios
dotnet test USBAnywhere.sln -c Release --no-build --verbosity normal
```

### Empaquetado de Versiones
Para compilar los instaladores Inno Setup, paquetes ZIP portables (x64 y ARM64) y firmas SHA-256:
```powershell
.\client\Publish-Release.ps1 -Version "3.0.1"
```

---

## 📄 Licencia

Licencia GPL-3.0. Desarrollado por [oscarlosu-lab](https://github.com/oscarlosu-lab).
