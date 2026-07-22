#!/bin/bash

LOCAL="$HOME/GoogleDrive/"
REMOTE="gdrive:DriveSyncFiles"
BACKUP="grive:Backups/sync"

echo "⬇️ Sync Drive → Local"
rclone sync "$REMOTE" "$LOCAL" \
  --fast-list \
  --create-empty-src-dirs \
  --backup-dir "$BACKUP/drive-$(date +%F-%H%M)" \
  --suffix ".from-drive"

echo "⬆️ Sync Local → Drive"
rclone sync "$LOCAL" "$REMOTE" \
  --fast-list \
  --backup-dir "$BACKUP/local-$(date +%F-%H%M)" \
  --suffix ".from-local"

