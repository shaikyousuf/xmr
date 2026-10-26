#!/bin/bash

echo "=== [1/6] Cleaning up ==="
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

echo "=== [4/6] Copying Firmware to /tmp (Bypasses Sandbox) ==="
export HOME=/tmp
rm -rf /tmp/.config/shadps4/sys_modules
mkdir -p /tmp/.config/shadps4/sys_modules
cp -r /mnt/games/sys_modules/* /tmp/.config/shadps4/sys_modules/
echo "Firmware files copied: $(ls /tmp/.config/shadps4/sys_modules/ | wc -l) files."

echo "=== [5/6] Linking Games ==="
rm -rf /tmp/.local/share/shadPS4/games
mkdir -p /tmp/.local/share/shadPS4
ln -sfn /mnt/games/PS4 /tmp/.local/share/shadPS4/games

echo "=== [6/6] Launching UI ==="
export APPIMAGE_EXTRACT_AND_RUN=1
export XDG_RUNTIME_DIR=/tmp
export QT_QPA_PLATFORM=xcb
export DISPLAY=:0

# Launch
xinit /opt/shadps4/shadps4 -b

# Print log on exit
echo "=================================================="
echo "UI CLOSED. HERE IS THE FRESH LOG:"
echo "=================================================="
cat /tmp/.local/share/shadPS4/log/shadps4.log 2>/dev/null || echo "Log file not found."
