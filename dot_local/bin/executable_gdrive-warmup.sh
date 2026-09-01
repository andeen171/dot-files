#!/bin/bash
# Pre-warms rclone's VFS directory cache for the Google Drive mount right
# after login, so the first thing that touches it (Obsidian scanning the
# whole vault) doesn't pay the cost of listing every folder one at a time
# over the network (measured: 78s cold vs 6s via vfs/refresh recursive).
#
# The omarchy-rclone plugin's login-mount reconciler runs inside the bar
# widget and is not instant, so this polls for the mount to actually exist
# before asking the daemon to refresh it.
set -euo pipefail

PLUGIN_DIR="$HOME/.config/omarchy/plugins/io.github.davidszp.omarchy-rclone"
ENV_FILE="$HOME/.config/rclone/rcd.env"
FS="gdrive:DriveSyncFiles"
MOUNTPOINT="$HOME/GoogleDrive"

[ -d "$PLUGIN_DIR" ] || exit 0
[ -f "$ENV_FILE" ] || exit 0

for _ in $(seq 1 60); do
  mountpoint -q "$MOUNTPOINT" && break
  sleep 1
done
mountpoint -q "$MOUNTPOINT" || exit 0

python3 - "$PLUGIN_DIR" "$ENV_FILE" "$FS" <<'PY'
import sys
sys.path.insert(0, sys.argv[1])
import rcclient

env = rcclient.read_env(sys.argv[2])
payload, error = rcclient.call(
    "vfs/refresh", {"fs": sys.argv[3], "recursive": "true"}, 120, env
)
if error:
    print("gdrive-warmup: %s" % error, file=sys.stderr)
    sys.exit(1)
print("gdrive-warmup: warmed %s" % payload)
PY
