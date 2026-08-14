#!/bin/bash
set -euo pipefail

LOCAL="$HOME/GoogleDrive/"
REMOTE="gdrive:DriveSyncFiles"
BACKUP_LOCAL="$HOME/GoogleDriveBackups/bisync"
BACKUP_REMOTE="gdrive:Backups/bisync"

mkdir -p "$BACKUP_LOCAL"

# True bidirectional sync: rclone compares both sides (size/modtime) and only
# propagates real changes, instead of two one-way `sync` mirrors that blindly
# overwrite whichever side runs last (which caused active edits to be
# clobbered by a stale remote copy - see incident 2026-08-14).
#
# --conflict-resolve newer: if the *same* file changed on both sides between
#   runs, auto-keep the newer one instead of aborting.
# --backup-dir1/2: whatever loses a conflict (or gets overwritten/deleted)
#   is archived here first, so nothing is ever silently destroyed.
# --recover: let a normal run recover from a prior interruption without
#   requiring a manual --resync (needed since this runs unattended via timer).
echo "🔄 Bisync Local <-> Drive"
rclone bisync "$LOCAL" "$REMOTE" \
  --fast-list \
  --create-empty-src-dirs \
  --conflict-resolve newer \
  --conflict-suffix "conflict-local,conflict-drive" \
  --backup-dir1 "$BACKUP_LOCAL" \
  --backup-dir2 "$BACKUP_REMOTE" \
  --recover \
  --resilient
