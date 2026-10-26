#!/bin/bash

echo "=== [1/6] Cleaning up old processes ==="
pkill -9 shadps4 2>/dev/null || true
pkill -9 Xorg 2>/dev/null || true

echo "=== [2/6] Setting up 4GB RAM disk for /tmp ==="
umount /tmp 2>/dev/null || true
rm -rf /tmp/*
mount -t tmpfs -o size=4G tmpfs /tmp

echo "=== [3/6] Mounting GAMES drive ==="
umount /mnt/games 2>/dev/null || true
mkdir -p /mnt/games
GAMES_DEV=$(blkid -L GAMES)
if [ -z "$GAMES_DEV" ]; then
    echo "CRITICAL ERROR: Could not find partition labeled GAMES."
    exit 1
fi
mount -t ntfs3 -o ro "$GAMES_DEV" /mnt/games
echo "Mounted $GAMES_DEV to /mnt/games"

echo "=== [4/6] COPYING Firmware (Bypasses sandbox issues) ==="
rm -rf /root/.config/shadps4/sys_modules
mkdir -p /root/.config/shadps4/sys_modules
# Copy the files instead of linking
cp -r /mnt/games/sys_modules/* /root/.config/shadps4/sys_modules/ 2>/dev/null
echo "Firmware files copied: $(ls /root/.config/shadps4/sys_modules/ | wc -l) files."

echo "=== [5/6] Linking Games & Clearing Logs ==="
rm -rf /root/.local/share/shadPS4/games
mkdir -p /root/.local/share/shadPS4
ln -sfn /mnt/games/PS4 /root/.local/share/shadPS4/games
rm -f /root/.local/share/shadPS4/log/shadps4.log

echo "=== [6/6] Launching UI (Intel Graphics) ==="
export APPIMAGE_EXTRACT_AND_RUN=1
export XDG_RUNTIME_DIR=/tmp
export QT_QPA_PLATFORM=xcb
export DISPLAY=:0

# Launch using xinit (the most reliable method)
xinit /opt/shadps4/shadps4 -b

# If the UI closes/crashes, print the log
echo "=================================================="
echo "UI CLOSED. HERE IS THE FRESH LOG:"
echo "=================================================="
cat /root/.local/share/shadPS4/log/shadps4.log 2>/dev/null || echo "Log file was not created."
