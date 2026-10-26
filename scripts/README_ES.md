# ⚡ Scripts de Automatización y Despliegue de USBAnywhere

🌐 **Idioma / Language:** [English](README.md) | **Español**

Este directorio contiene scripts de aprovisionamiento, suites de control y herramientas de automatización multimedia para el ecosistema USBAnywhere.

[![Licencia](https://img.shields.io/badge/Licencia-GPLv3-blue.svg?style=flat-square)](https://www.gnu.org/licenses/gpl-3.0)
[![Ko-fi](https://img.shields.io/badge/Ko--fi-Apoyar%20Proyecto-FF5E5B?style=flat-square&logo=ko-fi&logoColor=white)](https://ko-fi.com/oscarlosu)

---

## 📜 Índice de Scripts

### 1. `usbanywhere-ctl` — Suite de Control Unificada (macOS y Linux)
Panel interactivo con interfaz TUI para terminal y herramienta de gestión CLI sin dependencias externas.
- **Panel de Control Interactivo (TUI)**: `usbanywhere-ctl` (o `usbanywhere-ctl dashboard`)
- **Doctor del Sistema**: `usbanywhere-ctl doctor`
- **Autoprueba del Protocolo**: `usbanywhere-ctl test`
- **Gestión del Servicio**: `sudo usbanywhere-ctl start|stop|restart|status`
- **Gestión de Dispositivos**: `usbanywhere-ctl list`, `sudo usbanywhere-ctl share <busid>`

### 2. Instalación nativa para macOS

Arrastra USBAnywhere.app a Aplicaciones, ábrela y completa la configuración.
La aplicación y el servicio Swift no necesitan Python; la CLI opcional requiere
Python 3 y se instala junto con el servicio.

Los scripts `install-server-mac.sh`, `uninstall-server-mac.sh` y `usbanywhere-ctl`
de este repositorio delegan en `server-windows/scripts/`, la implementación única.

```sh
git submodule update --init server-windows
server-windows/src/USBAnywhere.Server.Mac/build.sh
sudo sh scripts/install-server-mac.sh IP_MAC IP_WINDOWS
python3 scripts/usbanywhere-ctl status --json
```

Añade dispositivos desde la aplicación. `share`, `unshare` y `reconnect` usan los
mismos permisos e identidades. Solo iniciar/detener/reiniciar el servicio necesita
sudo. En Mac, `test` verifica el control local; la prueba de red USB/IP debe
realizarse desde un cliente autorizado. Consulta la [guía de Mac](../server-windows/src/USBAnywhere.Server.Mac/README.md).

### 3. `install-server-linux.sh` / `install-server.sh` — Instalador 1-Click para Linux y Raspberry Pi
Instalador automático para distribuciones Linux y Raspberry Pi OS (Debian/Ubuntu/Raspbian/Arch/Fedora).
- Carga módulos del núcleo `usbip_core` y `usbip_host`.
- Instala paquete de espacio de usuario `usbip` y servicio systemd.
- Configura regla udev para auto-exportar en caliente.
- Instala `usbanywhere-ctl` en `/usr/local/bin/`.

```bash
curl -fsSL https://raw.githubusercontent.com/oscarlosu-lab/USBAnywhere-Server/main/scripts/install-server-linux.sh | sudo bash
```

### 4. Generadores Multimedia y Vídeos Tutoriales
Utilidades en Python basadas en MoviePy, Pillow y la API de ElevenLabs para renderizar tutoriales y guías interactivas:
- `generate_laser_lightburn_video.py` — Genera el vídeo tutorial de configuración con grabadoras láser y LightBurn.
- `generate_masterclass_video.py` — Produce la Masterclass para SimRacing, mandos de vuelo (HOTAS) y baja latencia.
- `generate_thumbnails.py` y `generate_laser_thumbnails.py` — Diseña miniaturas oficiales para YouTube.

---

## 📄 Licencia

Licencia GPL-3.0. Desarrollado por [oscarlosu-lab](https://github.com/oscarlosu-lab).
