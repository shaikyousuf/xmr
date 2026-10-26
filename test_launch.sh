#!/bin/bash

echo "=== [1/5] Cleaning up old processes ==="
pkill -9 shadps4 2>/dev/null || true
pkill -9 Xorg 2>/dev/null || true

echo "=== [2/5] Setting up 4GB RAM disk ==="
umount /tmp 2>/dev/null || true
rm -rf /tmp/*
mount -t tmpfs -o size=4G tmpfs /tmp

echo "=== [3/5] Mounting GAMES drive safely ==="
mkdir -p /mnt/games
umount /mnt/games 2>/dev/null || true
GAMES_DEV=$(blkid -L GAMES)
if [ -n "$GAMES_DEV" ]; then
    mount -t ntfs3 -o ro "$GAMES_DEV" /mnt/games
fi

echo "=== [4/5] Fixing Symlinks & Clearing Logs ==="
rm -rf /root/.config/shadps4/sys_modules
mkdir -p /root/.config/shadps4
ln -sfn /mnt/games/sys_modules /root/.config/shadps4/sys_modules

rm -rf /root/.local/share/shadPS4/games
mkdir -p /root/.local/share/shadPS4
ln -sfn /mnt/games/PS4 /root/.local/share/shadPS4/games

# Delete the old log so we only see fresh errors
rm -f /root/.local/share/shadPS4/log/shadps4.log

echo "=== [5/5] Launching UI ==="
export APPIMAGE_EXTRACT_AND_RUN=1
export XDG_RUNTIME_DIR=/tmp
export QT_QPA_PLATFORM=xcb

# Start the UI
xinit /opt/shadps4/shadps4 -b
