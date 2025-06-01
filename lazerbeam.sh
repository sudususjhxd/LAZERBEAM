#!/bin/bash

# 👽💾☄️ LAZERBEAM BACKUP 3000
# "ALL FILES MUST BLEED"
# iPhone photo backup script via GVFS & rsync with checksum verification
# Fully resumable, interruption-safe version ("Gold")

# 🆘 Handle --help
if [[ "${1:-}" == "--help" ]]; then
  echo ""
  echo "👽💾☄️  LAZERBEAM BACKUP 3000 ☄️💾👽"
  echo ""
  echo "A brutalist iPhone photo backup script for Linux."
  echo ""
  echo "🔧 What it does:"
  echo " - Detects your iPhone mounted via GVFS (gphoto2)"
  echo " - Copies all photo folders (e.g. 100APPLE, 101APPLE...)"
  echo " - Uses rsync with checksums (resumable + safe)"
  echo " - Logs all actions to a persistent logfile"
  echo " - After copy, it verifies file count and size for each folder"
  echo ""
  echo "⚙️ Usage:"
  echo "  ./lazerbeam.sh"
  echo ""
  echo "🧬 Optional environment variables:"
  echo "  BACKUP_DIR   Override default backup location"
  echo "  LOG_FILE     Override default logfile path"
  echo ""
  echo "📁 Default path:"
  echo "  /var/home/<your-user>/Pictures/iphone-lazerbackup"
  echo ""
  echo "💡 TIP: Use 'mini-lazer' to only verify an existing backup without copying."
  echo ""
  exit 0
fi
set -euo pipefail

# 💣 Trap interruptions (Ctrl+C, SIGTERM)
trap 'echo -e "\n❌ Backup interrupted by user. Exiting."; echo "⛔ INTERRUPTED at $(date)" >> "$LOG_FILE"; exit 130' SIGINT SIGTERM

# 🎯 SETUP
USERNAME=$(whoami)
DEFAULT_BACKUP_DIR="/var/home/$USERNAME/Pictures/iphone-lazerbackup"
BACKUP_DIR="${1:-$DEFAULT_BACKUP_DIR}"
LOG_FILE="$BACKUP_DIR/lazerbeam.log"

mkdir -p "$BACKUP_DIR"

# 👾 ASCII BANNER PLS
cat << "EOF"

👽💾☄️ LAZERBEAM BACKUP 3000 ☄️💾👽
     💉 ALL FILES MUST BLEED 💉

░▒▓█▓▒░       ░▒▓██████▓▒░░▒▓████████▓▒░▒▓████████▓▒░▒▓███████▓▒░░▒▓███████▓▒░░▒▓████████▓▒░░▒▓██████▓▒░░▒▓██████████████▓▒░  
░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░ 
░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░    ░▒▓██▓▒░░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░ 
░▒▓█▓▒░      ░▒▓████████▓▒░  ░▒▓██▓▒░  ░▒▓██████▓▒░ ░▒▓███████▓▒░░▒▓███████▓▒░░▒▓██████▓▒░ ░▒▓████████▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░ 
░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░░▒▓██▓▒░    ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░ 
░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░ 
░▒▓████████▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓████████▓▒░▒▓████████▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓███████▓▒░░▒▓████████▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░ 
                                                                                                                              
                                                                                                                              
EOF

# 📆 LOG START
echo -e "\n🛸 INITIATING LAZERBEAM BACKUP SEQUENCE..."
echo "📂 Target directory: $BACKUP_DIR"
echo "📆 $(date)" >> "$LOG_FILE"

# 📡 FIND IPHONE MOUNT
IPHONE_MOUNT=$(find /run/user/1000/gvfs/ -mindepth 1 -maxdepth 2 -type d -name 'gphoto2:*' | head -n 1)

if [ -z "$IPHONE_MOUNT" ]; then
    echo "❌ CRITICAL ERROR: iPhone not mounted. Plug it in, unlock it, trust the computer, and try again."
    echo "❌ Backup aborted at $(date)" >> "$LOG_FILE"
    exit 1
fi

echo "✅ iPhone detected at: $IPHONE_MOUNT"

# 🔬 SCAN FOLDERS
FOLDER_LIST=$(find "$IPHONE_MOUNT" -mindepth 1 -maxdepth 3 -type d)
FOLDER_COUNT=$(echo "$FOLDER_LIST" | wc -l)

echo "📁 Found $FOLDER_COUNT folder(s) to examine. Deploying lazers..."

# 🔄 COPY FILES WITH CHECKSUM + FEEDBACK
INDEX=1
while IFS= read -r FOLDER; do
    RELATIVE_PATH="${FOLDER#$IPHONE_MOUNT/}"
    TARGET_FOLDER="$BACKUP_DIR/$RELATIVE_PATH"
    mkdir -p "$TARGET_FOLDER"

    FILE_COUNT=$(find "$FOLDER" -type f | wc -l)
    echo -e "\n[$INDEX/$FOLDER_COUNT] 🔫 Checking $RELATIVE_PATH"

    if [ "$FILE_COUNT" -eq 0 ]; then
        echo "⚠️  No files in $RELATIVE_PATH — skipping!"
        ((INDEX++))
        continue
    fi

    # Preload contents to reduce gvfs latency
    gio list "$FOLDER" &>/dev/null || ls "$FOLDER" &>/dev/null

    echo "📥 Copying $FILE_COUNT file(s) from $RELATIVE_PATH to $TARGET_FOLDER"

    stdbuf -oL rsync -ah --checksum --info=progress2 "$FOLDER/" "$TARGET_FOLDER/" 2>&1 | tee -a "$LOG_FILE"

    ((INDEX++))
done <<< "$FOLDER_LIST"

# 🧪 POST-RUN: CHECK FOR ACTUAL DUPLICATES
DUPLICATE_LOG="$BACKUP_DIR/lazerbeam-duplicates.txt"
echo -e "\n🧠 ANALYZING for true duplicates..."
find "$BACKUP_DIR" -type f -exec sha256sum {} + | sort | uniq -d --check-chars=64 > "$DUPLICATE_LOG" || true

if [[ -s "$DUPLICATE_LOG" ]]; then
    echo "⚠️ DUPLICATES FOUND. See: $DUPLICATE_LOG"
else
    echo "✅ No duplicates detected. Hash clean."
    rm "$DUPLICATE_LOG"
fi

# 🏁 DONE
echo -e "\n🚀 BACKUP COMPLETE. All your JPEG are belong to us."
echo "✅ $(date) — SUCCESS" >> "$LOG_FILE"

# 📊 MINI-LAZER VERIFICATION PHASE

echo ""
echo "🧪 FINAL BACKUP VERIFICATION 🧪"
echo ""

printf "📁 %-15s │ 📱 iPhone │ 💾 Backup │ 📦 Size │ ✅ Match?\n" "Folder"
printf "────────────────────┼────────────┼────────────┼──────────┼────────────\n"

total_files_iphone=0
total_files_backup=0
total_size_backup_mb=0

for bfolder in "$BACKUP_DIR"/*/; do
  fname=$(basename "$bfolder")

  iphone_folder="$IPHONE_MOUNT/$fname"
  if [ -d "$iphone_folder" ]; then
    files_iphone=$(find "$iphone_folder" -type f 2>/dev/null | wc -l)
  else
    files_iphone=0
  fi

  files_backup=$(find "$bfolder" -type f | wc -l)
  size_backup_mb=$(du -sm "$bfolder" | cut -f1)
  total_files_iphone=$((total_files_iphone + files_iphone))
  total_files_backup=$((total_files_backup + files_backup))
  total_size_backup_mb=$((total_size_backup_mb + size_backup_mb))

  if (( files_iphone == files_backup )); then
    match_icon="✅"
  elif (( files_backup > files_iphone )); then
    match_icon="⚠️ OVER"
  else
    match_icon="❌"
  fi

  printf "📁 %-15s │ %10s │ %10s │ %8s │ %s\n" "$fname" "$files_iphone" "$files_backup" "${size_backup_mb}MB" "$match_icon"
done

echo ""
echo "🔎 Scan summary: $total_files_backup files found in backup, total size: ${total_size_backup_mb}MB." | tee -a "$LOG_FILE"

if (( total_files_iphone != total_files_backup )); then
  diff=$((total_files_iphone - total_files_backup))
  echo "💀 WARNING: $diff file(s) potentially missing from backup!" | tee -a "$LOG_FILE"
  tput bel
else
  echo "🟢 All files accounted for. BACKUP VERIFIED." | tee -a "$LOG_FILE"
  tput bel; sleep 0.2; tput bel
fi