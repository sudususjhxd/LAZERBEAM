# 💾 LASERBEAM BACKUP 3000

> IMMA CHARGIN MAH RSYNC

A ridiculous but effective script to back up photos and videos from your iPhone using Linux (Fedora, Ubuntu, Arch etc).  
It uses GNOME/KDE's GVFS and `rsync` with checksumming to detect actual duplicates and avoid copying the same files again.

---

## 🪐 FEATURES

- 🚀 Auto-detects your iPhone via GVFS
- 📂 Copies all folders (e.g., `DCIM`, `2023__`)
- 🔄 Uses `rsync --checksum` to avoid duplicates by **content**, not just filename
- 💬 Meme-fueled command line output
- 🧪 Post-run SHA256-based duplicate checker
- 📜 Logs every run to `laserbeam.log`

---

## ⚙️ REQUIREMENTS

- An unlocked and trusted iPhone (on Linux desktop)
- GNOME/KDE + `gvfs`, `gvfs-afc`, `gvfs-gphoto2`
- `rsync`, `sha256sum`

On Fedora:

```bash
sudo dnf install rsync gvfs gvfs-afc gvfs-gphoto2

ENJOY!
