# 🗺️ Roadmap de Mejoras Técnicas y Futuras — USBAnywhere

🌐 **Idioma / Language:** [English](ROADMAP_EN.md) | **Español**

Este documento recopila las áreas de optimización, mejoras de arquitectura y nuevas funcionalidades implementadas y planificadas para el ecosistema **USBAnywhere** (Cliente Windows, Servidores Windows, macOS, Linux y Android).

[![Licencia](https://img.shields.io/badge/Licencia-GPLv3-blue.svg?style=flat-square)](https://www.gnu.org/licenses/gpl-3.0)
[![Ko-fi](https://img.shields.io/badge/Ko--fi-Apoyar%20Proyecto-FF5E5B?style=flat-square&logo=ko-fi&logoColor=white)](https://ko-fi.com/oscarlosu)

---

## ⚡ 1. Rendimiento y Protocolo USB/IP

| Mejora | Impacto | Estado | Descripción Técnica |
|---|---|---|---|
| **Soporte de Modos de Recepción (`--receive-mode`)** | **Alto** | ✅ **v3.0.0** | Selección entre `zero-copy` (máximo throughput para discos y cámaras) y `low-latency` (callbacks WSK en kernel para HID, ratones, volantes SimRacing y HOTAS). |
| **Desconexión Limpia en Apagado / Salida (`Graceful Detach`)** | **Alto** | ✅ **v3.0.1** | Desacoplamiento asíncrono ordenado de todos los puertos USB activos al pulsar Alt+F4 o cerrar la app, evitando puertos bloqueados en estado *busy* en los servidores remotos. |
| **Integridad de Binarios y Controladores** | **Alto** | ✅ **v3.0.1** | Sincronización estricta de hashes SHA-256 de `usbipw.exe` y validación de firmas digitales Authenticode en ejecutables distribuidos. |
| **Compresión de Tráfico en Redes Lentas (WAN/VPN)** | **Medio** | ⏳ **Planificado v3.1** | Soporte opcional de compresión LZ4 o ZSTD sobre el túnel TCP para conexiones con ancho de banda limitado (útil sobre Tailscale y redes móviles 4G/5G). |
| **Transporte UDP / WebRTC de Ultrabaja Latencia** | **Investigación** | 🔬 **I+D** | Investigación de túneles UDP con retransmisión selectiva para periféricos HID de alta tasa de sondeo (1000 Hz / 8000 Hz). |

---

## 🛡️ 2. Servidores Multiplataforma y Ecosistema

| Componente / Servidor | Plataforma | Estado | Descripción Técnica |
|---|---|---|---|
| **Servidor macOS Nativo** | 🍎 macOS (Apple Silicon M1-M4 & Intel) | ✅ **v3.0.1** | Servidor nativo en Swift 5.9+ con Userspace IOKit (`IOUSBHostInterface`), sin extensiones de kernel (`.kext`) ni bypass de SIP. Demonio administrado por `launchd` e instalador 1-click. |
| **Servidor Windows de Escritorio** | 🖥️ Windows 10/11 (x64) | ✅ **v3.0.1** | Servidor con interfaz gráfica moderna en .NET 9.0, bandeja del sistema, auto-bind persistente y regla de Firewall acotada a redes privadas. |
| **Servidor Linux / Raspberry Pi** | 🐧 Linux / RPi OS | ✅ **v3.0.0** | Instalador `install-server.sh` 1-click con demonio `systemd` y regla `udev` hotplug para auto-exportar periféricos en caliente. |
| **Servidor Android** | 📱 Android 10+ (TV / Móvil) | ✅ **v3.0.0** | Servidor USB/IP rootless para Android y Android TV con integración Sunshine / Moonlight y soporte DualSense. |

---

## 💻 3. Interfaz Gráfica y Experiencia de Usuario (WPF / UI)

| Mejora | Impacto | Estado | Descripción Técnica |
|---|---|---|---|
| **Selector Visual de Modo de Latencia** | **Alto** | ✅ **v3.0.0** | Conmutador interactivo en la barra inferior (`⚡ Modo: Zero-Copy` / `🏎️ Modo: Low-Latency`) con persistencia inmediata en `config.json`. |
| **Diagnóstico Transparente de Red** | **Alto** | ✅ **v3.0.1** | Mensajes de error claros e informativos en la interfaz cuando el servidor remoto (puerto 3240) no responde, reemplazando bloqueos silenciosos. |
| **Medidor de Latencia en Tiempo Real (`[ms]`)** | **Alto** | ✅ **v3.0.0** | Visualización en tiempo real del ping TCP (`[2ms]`) junto a cada servidor descubierto en el árbol de dispositivos. |
| **Temas Dinámicos (Oscuro / Claro) y Multiidioma** | **Medio** | ✅ **v3.0.0** | Conmutación instantánea de tema y lenguaje (EN/ES) en caliente mediante `DynamicResource`. |
| **Exportación / Importación de Perfiles y Favoritos** | **Bajo** | ⏳ **Planificado v3.1** | Capacidad de exportar e importar listas de servidores y dispositivos favoritos en formato JSON para despliegues masivos. |

---

## 🧪 4. Calidad, Testing y Automatización CI/CD

| Verificación | Plataforma | Estado | Cobertura |
|---|---|---|---|
| **Tests Unitarios del Cliente** | Windows runner | ✅ **74 Tests** | Normalización `usb.ids`, `InputValidator`, `ConfigService`, `SignatureVerifier` y ciclo de vida de drivers. |
| **Tests Unitarios del Servidor Windows** | Windows runner | ✅ **54 Tests** | Modelos, configuración, orquestador PnP y validación de red. |
| **Tests Unitarios del Servidor macOS** | macOS Apple Silicon runner | ✅ **5 Tests** | Serialización big-endian, codificación de URBs y estructuras USB/IP. |
| **Test de Integración Live TCP en macOS** | macOS Apple Silicon runner | ✅ **Activo en CI** | Levanta el demonio en macOS, ejecuta `list` sobre IOKit y verifica el handshake binario TCP en el puerto 3240. |
| **Empaquetado Multi-Arquitectura** | Windows (x64 & ARM64) | ✅ **v3.0.1** | Compilación separada de paquetes nativos x64 y ARM64 con sus respectivos manifiestos Scoop y WinGet. |

---

## 📄 Licencia

Licencia GPL-3.0. Desarrollado por [oscarlosu-lab](https://github.com/oscarlosu-lab).
