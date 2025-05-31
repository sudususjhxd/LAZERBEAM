# 💾 LAZERBEAM BACKUP 3000

> IMMA CHARGIN MAH RSYNC

A ridiculous but effective script to back up photos and videos from your iPhone using Linux (Fedora, Ubuntu, Arch etc).  
It uses GNOME/KDE's GVFS and `rsync` with checksumming to detect actual duplicates and avoid copying the same files again.

---

## 🤕 WHY?

Copying thousands of files from an iPhone to Linux is a pain.  
Half the tools are buggy, most apps fail silently, and USB/iOS/GVFS just... doesn't want to cooperate.  
(It’s probably **my fault for using immutable Fedora Silverblue ATM** — but that’s why this script exists.)

It was created out of necessity:  
📸 **my partner had over 12,000 photos stuck on her iPhone**  
*(I love her, but my soul dies a little every time I look into her phone and see stacks of screenshots, alien memes, and 20 near-identical photos of the same object)*  
💀 and nothing wanted to back them up reliably.  
So... this is LAZERBEAM.

---

## 🪐 FEATURES

- 🚀 Auto-detects your iPhone via GVFS
- 📂 Copies all folders (e.g., `DCIM`, `2023__`)
- 🔄 Uses `rsync --checksum` to avoid duplicates by **content**, not just filename
- 💬 Meme-fueled command line output
- 🧪 Post-run SHA256-based duplicate checker
- 📜 Logs every run to `lazerbeam.log`

---

## ⚙️ REQUIREMENTS

- An unlocked and trusted iPhone (on Linux desktop)
- GNOME/KDE + `gvfs`, `gvfs-afc`, `gvfs-gphoto2`
- `rsync`, `sha256sum`

### Fedora:

```bash
sudo dnf install rsync gvfs gvfs-afc gvfs-gphoto2
```

### Debian/Ubuntu:

```bash
sudo apt install rsync gvfs-backends gvfs-bin
```

---

## 🧠 USAGE

1. Plug your iPhone and unlock it  
2. Trust the computer  
3. Clone and run:

```bash
git clone https://github.com/YOUR_USERNAME/lazerbeam-backup.git
cd lazerbeam-backup
chmod +x lazerbeam.sh
./lazerbeam.sh
```

4. Files will be backed up to:

```
/var/home/YOUR_USER/Pictures/iphone-lazerbackup
```

Optional: pass your own destination folder as argument:

```bash
./lazerbeam.sh /mnt/BACKUPS/pamela/
```

---

## 🛡️ WARNINGS

- **This does not delete anything** from your phone.
- Duplicate check is by SHA256, not by filename.
- This relies on GVFS — make sure your phone shows up in `nautilus` or `dolphin`.
- If you're on Fedora Silverblue or Kinoite, expect some extra resistance from the universe 🧊

---

## 🧨 DISCLAIMER

I trust this script to back up *my* iPhone photos,  
but I make **no guarantees** that it won’t explode, eat your cat, or summon a GNOME daemon from 2007.  
You run it at your own risk — and please make a second backup if it really matters.

---

## 📜 LICENSE

GNU General Public License v3.0

Fork it, meme it, improve it.

🧠 "All your photos are belong to us & POLAND STRONK"
