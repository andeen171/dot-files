#!/bin/bash
set -euo pipefail

LOCAL="$HOME/GoogleDrive/"
REMOTE="gdrive:DriveSyncFiles"
BACKUP_LOCAL="$HOME/GoogleDriveBackups/sync"
BACKUP_REMOTE="gdrive:Backups/sync"
STAMP="$(date +%F-%H%M)"

echo "⬇️ Sync Drive → Local"
rclone sync "$REMOTE" "$LOCAL" \
  --fast-list \
  --create-empty-src-dirs \
  --backup-dir "$BACKUP_LOCAL/drive-$STAMP" \
  --suffix ".from-drive"

echo "⬆️ Sync Local → Drive"
rclone sync "$LOCAL" "$REMOTE" \
  --fast-list \
  --backup-dir "$BACKUP_REMOTE/local-$STAMP" \
  --suffix ".from-local"

