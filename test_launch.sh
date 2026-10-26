#!/bin/bash

echo "=== [1/6] Cleaning up old processes ==="
pkill -9 shadps4 2>/dev/null || true
pkill -9 Xorg 2>/dev/null || true

echo "=== [2/6] Setting up 4GB RAM disk for /tmp ==="
umount /tmp 2>/dev/null || true
rm -rf /tmp/*
mount -t tmpfs -o size=4G tmpfs /tmp

echo "=== [3/6] Mounting GAMES drive safely ==="
mkdir -p /mnt/games
umount /mnt/games 2>/dev/null || true
GAMES_DEV=$(blkid -L GAMES)
if [ -z "$GAMES_DEV" ]; then
    echo "ERROR: Could not find partition labeled GAMES."
    exit 1
fi
mount -t ntfs3 -o ro "$GAMES_DEV" /mnt/games
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to mount $GAMES_DEV."
    exit 1
fi

echo "=== [4/6] Fixing Symlinks (Prevents nesting) ==="
rm -rf /root/.config/shadps4/sys_modules
mkdir -p /root/.config/shadps4
ln -sfn /mnt/games/sys_modules /root/.config/shadps4/sys_modules

rm -rf /root/.local/share/shadPS4/games
mkdir -p /root/.local/share/shadPS4
ln -sfn /mnt/games/PS4 /root/.local/share/shadPS4/games

echo "=== [5/6] Clearing Old Logs ==="
rm -f /root/.local/share/shadPS4/log/shadps4.log

echo "=== [6/6] Launching UI (Intel Mode) ==="
export APPIMAGE_EXTRACT_AND_RUN=1
export XDG_RUNTIME_DIR=/tmp
export QT_QPA_PLATFORM=xcb
export DISPLAY=:0

# Start Xorg in the background
Xorg :0 &
sleep 2

# Launch the emulator
/opt/shadps4/shadps4 -b

# Once the UI closes or crashes, print the log
echo "=================================================="
echo "UI CLOSED OR CRASHED. HERE IS THE FRESH LOG:"
echo "=================================================="
cat /root/.local/share/shadPS4/log/shadps4.log
