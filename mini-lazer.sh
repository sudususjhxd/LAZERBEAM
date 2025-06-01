#!/bin/bash

cat << "EOF"
░▒▓██████████████▓▒░░▒▓█▓▒░▒▓███████▓▒░░▒▓█▓▒░                     
░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░                     
░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░                     
░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░                     
░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░                     
░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░                     

░▒▓█▓▒░       ░▒▓██████▓▒░░▒▓████████▓▒░▒▓████████▓▒░▒▓███████▓▒░  
░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░ 
░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░    ░▒▓██▓▒░░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░ 
░▒▓█▓▒░      ░▒▓████████▓▒░  ░▒▓██▓▒░  ░▒▓██████▓▒░ ░▒▓███████▓▒░  
░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░░▒▓██▓▒░    ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░ 
░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░ 
░▒▓████████▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓████████▓▒░▒▓████████▓▒░▒▓█▓▒░░▒▓█▓▒░ 
EOF
# 🆘 Handle --help
if [[ "${1:-}" == "--help" ]]; then
  echo ""
  echo "🛰️  MINI-LAZER - Backup Verification Mode"
  echo ""
  echo "This script checks your iPhone photo backup integrity."
  echo ""
  echo "🔧 What it does:"
  echo " - Compares file count between your iPhone and your backup"
  echo " - Calculates total folder sizes"
  echo " - Marks mismatches with ❌, ✅ or ⚠️"
  echo " - Appends results to the LAZERBEAM log file (if run from main script)"
  echo ""
  echo "⚙️ Usage:"
  echo "  ./mini-lazer.sh"
  echo ""
  echo "🧬 Optional environment variables:"
  echo "  BACKUP_DIR   Override default backup folder"
  echo ""
  echo "📁 Default path:"
  echo "  /var/home/<your-user>/Pictures/iphone-lazerbackup"
  echo ""
  exit 0
fi


if [[ "${1:-}" == "--help" ]]; then
  echo ""
  echo "🛰️  MINI-LAZER - iPhone Backup Verifier"
  echo ""
  echo "Usage: ./mini-lazer.sh"
  echo ""
  echo "This script checks if your iPhone photos were successfully copied into:"
  echo "  $BACKUP_DIR"
  echo ""
  echo "Environment variables:"
  echo "  BACKUP_DIR   Override default backup location"
  echo ""
  echo "Example:"
  echo "  BACKUP_DIR=/mnt/storage/iphone ./mini-lazer.sh"
  echo ""
  exit 0
fi
# 🔍 MINI-LAZER: Verification-Only Mode
# Checks backup integrity after iPhone photo sync

set -euo pipefail

echo ""
echo "🧪 FINAL BACKUP VERIFICATION 🧪"
echo ""

printf "📁 %-15s │ 📱 iPhone │ 💾 Backup │ 📦 Size │ ✅ Match?
" "Folder"
printf "────────────────────┼────────────┼────────────┼──────────┼────────────
"

total_files_iphone=0
total_files_backup=0
total_size_backup_mb=0

IPHONE_MOUNT=$(find /run/user/$(id -u)/gvfs/ -type d -name "gphoto2:*" | head -n 1)
BACKUP_DIR="${BACKUP_DIR:-/var/home/$(whoami)/Pictures/iphone-lazerbackup}"

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

  printf "📁 %-15s │ %10s │ %10s │ %8s │ %s
" "$fname" "$files_iphone" "$files_backup" "${size_backup_mb}MB" "$match_icon"
done

echo ""
echo "🔎 Scan summary: $total_files_backup files found in backup, total size: ${total_size_backup_mb}MB."

if (( total_files_iphone != total_files_backup )); then
  diff=$((total_files_iphone - total_files_backup))
  echo "💀 WARNING: $diff file(s) potentially missing from backup!"
  tput bel
else
  echo "🟢 All files accounted for. BACKUP VERIFIED."
  tput bel; sleep 0.2; tput bel
fi