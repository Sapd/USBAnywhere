# 🗺️ Roadmap de Mejoras Técnicas y Futuras — USBAnywhere

Este documento recopila las áreas de optimización, mejoras de arquitectura y nuevas funcionalidades implementadas y planificadas para el cliente **USBAnywhere** en Windows.

---

## ⚡ 1. Rendimiento y Protocolo USB/IP

| Mejora | Impacto | Descripción Técnica |
|---|---|---|
| **Soporte de Modos de Recepción (`--receive-mode`)** | **Alto** | Permitir seleccionar entre `zero-copy` (máximo throughput para discos y cámaras) y `low-latency` (callbacks WSK en kernel para HID, ratones, volantes SimRacing y mandos de alta tasa de sondeo). *(✅ Implementado en v3.0.0 con selector directo en barra de estado)* |
| **Desconexión Limpia en Apagado / Salida (`Graceful Detach`)** | **Alto** | Liberar automáticamente todos los puertos USB activos al cerrar la aplicación o desinstalar drivers, evitando que el servidor Linux mantenga el bus en estado *busy*. *(✅ Implementado en v3.0.0)* |
| **Compresión de Tráfico en Redes Lentas** | **Medio** | Soporte opcional de compresión LZ4/ZSTD sobre el túnel TCP para conexiones con ancho de banda limitado (útil sobre VPN y Tailscale). |
| **Soporte de Sobrescritura de Número de Serie USB** | **Medio** | Aprovechar el flag `--serial <ID>` de `usbipw` para permitir asignar números de serie personalizados a periféricos clónicos o duplicados. |

---

## 🛡️ 2. Resiliencia de Drivers y Windows Kernel

| Mejora | Impacto | Descripción Técnica |
|---|---|---|
| **Detección PnP en Tiempo Real** | **Alto** | Consulta activa a `pnputil /enum-devices /class USB /connected` buscando el nodo `ROOT\USBIP_WIN2\UDE` para garantizar que la controladora host emulada esté efectivamente en estado `Iniciado`. *(✅ Implementado en v3.0.0)* |
| **Prevención de Controladoras Duplicadas** | **Alto** | Limpieza previa de nodos `ROOT\USBIP_WIN2\UDE` antes de invocar `devnode.exe install` tanto en la app como en el instalador Inno Setup para evitar acumular nodos `ROOT\USB\0001`, `0002`... *(✅ Implementado en v3.0.0)* |
| **Desinstalación PnP en Dos Fases sin Reinicio Forzado** | **Alto** | Remoción del nodo virtual UDE seguida de `/delete-driver /uninstall` y fallback `/force` en `DriverStore`, protegiendo los concentradores USB 3.0 físicos (`USB\ROOT_HUB30`) y adaptadores virtuales de terceros (`Parsec Virtual USB Adapter`). *(✅ Implementado en v3.0.0)* |
| **Watchdog de Estado del Servicio UDE** | **Medio** | Monitorizar el estado del servicio en segundo plano (`usbip2_ude`) y alertar al usuario si Windows suspende la controladora por ahorro de energía (Selective Suspend). |

---

## 💻 3. Interfaz Gráfica y Experiencia de Usuario (WPF / UI)

| Mejora | Impacto | Descripción Técnica |
|---|---|---|
| **Selector Visual de Modo de Latencia en Barra de Estado** | **Alto** | Conmutador interactivo en la barra inferior (`⚡ Modo: Zero-Copy` / `🏎️ Modo: Low-Latency`) con persistencia inmediata en `config.json`. *(✅ Implementado en v3.0.0)* |
| **Medidor de Latencia en Tiempo Real (`[ms]`)** | **Alto** | Visualización en tiempo real del ping TCP (`[2ms]`) junto a cada servidor descubierto en el árbol de dispositivos. *(✅ Implementado en v3.0.0)* |
| **Temas Dinámicos (Oscuro / Claro)** | **Medio** | Cambio instantáneo entre tema Oscuro y Claro en caliente mediante `DynamicResource`. *(✅ Implementado en v3.0.0)* |
| **Exportación / Importación de Perfiles y Favoritos** | **Bajo** | Capacidad de exportar e importar listas de servidores y dispositivos favoritos en formato JSON para facilitar despliegues en múltiples PCs. |

---

## 🌐 4. Conectividad y Redes Remotas (VPN / Cloud)

| Mejora | Impacto | Descripción Técnica |
|---|---|---|
| **Descubrimiento Activo en Tailscale, ZeroTier y WireGuard** | **Alto** | Escaneo asíncrono de peers VPN con sondeo TCP en puerto `3240` (`1000 ms` timeout) e importación directa al árbol principal. *(✅ Implementado en v3.0.0)* |
| **Auto-Instalador Plug & Play 1-Click para Linux (`install-server.sh`)** | **Alto** | Aprovisionamiento automático con servicio `systemd` y regla `udev` hotplug que auto-exporta cualquier USB conectado a la Raspberry Pi/Linux. *(✅ Implementado en v3.0.0)* |
| **Reconexión Exponencial Inteligente (Backoff)** | **Medio** | Algoritmo de reintento progresivo cuando el servidor remoto se reinicia o sufre fluctuaciones de Wi-Fi. |

---

## 🧪 5. Calidad, Testing y CI/CD

| Mejora | Impacto | Descripción Técnica |
|---|---|---|
| **Verificación Criptográfica Fail-Closed** | **Alto** | Validación estricta por hash SHA-256 de `devnode.exe` y de los paquetes del auto-actualizador (`SHA256SUMS.txt`) antes de cualquier ejecución. *(✅ Implementado en v3.0.0)* |
| **Suite de 67 Tests Unitarios (Zero-Trust)** | **Alto** | Cobertura de normalización hexadecimal `usb.ids`, persistencia atómica `ConfigService`, `InputValidator` y `LocalizationService`. *(✅ Implementado en v3.0.0)* |
| **Pipeline de GitHub Actions Automatizado** | **Alto** | Flujo de CI (`.github/workflows/ci.yml`) que compila la solución en Windows runner y ejecuta los 67 tests unitarios en cada push. *(✅ Implementado en v3.0.0)* |
