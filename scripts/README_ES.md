# ⚡ Scripts de Automatización y Despliegue de USBAnywhere

🌐 **Idioma / Language:** [English](README.md) | **Español**

Este directorio contiene scripts de aprovisionamiento del sistema y herramientas de automatización multimedia para el ecosistema USBAnywhere.

[![Licencia](https://img.shields.io/badge/Licencia-GPLv3-blue.svg?style=flat-square)](https://www.gnu.org/licenses/gpl-3.0)
[![Ko-fi](https://img.shields.io/badge/Ko--fi-Apoyar%20Proyecto-FF5E5B?style=flat-square&logo=ko-fi&logoColor=white)](https://ko-fi.com/oscarlosu)

---

## 📜 Índice de Scripts

### 1. `install-server.sh` — Instalador 1-Click para Servidor Linux y Raspberry Pi
Instalador automático para distribuciones Linux y Raspberry Pi OS (Debian/Ubuntu/Raspbian/Arch/Fedora).
- Carga automáticamente los módulos del núcleo `usbip_core` y `usbip_host`.
- Instala las herramientas de espacio de usuario de `usbip`.
- Configura el servicio systemd `/etc/systemd/system/usbipd.service` para arranque automático.
- Instala la regla udev `/etc/udev/rules.d/99-usbip-autobind.rules` para auto-exportar cualquier periférico USB conectado en caliente.

**Comando de instalación 1-Click**:
```bash
curl -fsSL https://raw.githubusercontent.com/oscarlosu-lab/USBAnywhere/main/scripts/install-server.sh | sudo bash
```

### 2. Generadores Multimedia y Vídeos Tutoriales
Utilidades en Python basadas en MoviePy, Pillow y la API de ElevenLabs para renderizar tutoriales y guías interactivas:
- `generate_laser_lightburn_video.py` — Genera el vídeo tutorial de configuración con grabadoras láser y LightBurn.
- `generate_masterclass_video.py` — Produce la Masterclass para SimRacing, mandos de vuelo (HOTAS) y baja latencia.
- `generate_thumbnails.py` y `generate_laser_thumbnails.py` — Diseña miniaturas oficiales para YouTube.

---

## 📄 Licencia

Licencia GPL-3.0. Desarrollado por [oscarlosu-lab](https://github.com/oscarlosu-lab).
