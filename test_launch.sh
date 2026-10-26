#!/bin/bash

echo "=== [1/7] Cleaning up ==="
pkill -9 shadps4 2>/dev/null || true
pkill -9 Xorg 2>/dev/null || true
rm -rf /root/.config/shadps4 /root/.local/share/shadPS4 /tmp/.config /tmp/.local
rm -rf /root/.config/shadPS4 /root/.local/share/shadps4

echo "=== [2/7] Installing xdotool (Focus Fixer) ==="
pacman -Sy --noconfirm xdotool

echo "=== [3/7] Setting up 4GB RAM disk ==="
umount /tmp 2>/dev/null || true
rm -rf /tmp/*
mount -t tmpfs -o size=4G tmpfs /tmp

echo "=== [4/7] Mounting GAMES drive ==="
umount /mnt/games 2>/dev/null || true
mkdir -p /mnt/games
mount -t ntfs3 -o ro /dev/nvme0n1p6 /mnt/games

echo "=== [5/7] Copying Firmware ==="
mkdir -p /tmp/.config/shadps4/sys_modules
cp -r /mnt/games/sys_modules/* /tmp/.config/shadps4/sys_modules/
mkdir -p /tmp/.local/share/shadPS4
ln -sfn /mnt/games/PS4 /tmp/.local/share/shadPS4/games

echo "=== [6/7] Setting Environment ==="
export XDG_CONFIG_HOME=/tmp/.config
export XDG_DATA_HOME=/tmp/.local/share
export XDG_RUNTIME_DIR=/tmp
export APPIMAGE_EXTRACT_AND_RUN=1
export QT_QPA_PLATFORM=xcb

echo "=== [7/7] Launching UI & Bypassing Popup ==="
# Start the UI in the background
xinit /opt/shadps4/shadps4 -b &

# Wait for the UI to render
sleep 15

# Send an 'Enter' keypress to the Xorg screen to close the popup
DISPLAY=:0 xdotool key Return

echo "Done. Switch to F1 to see the UI."
