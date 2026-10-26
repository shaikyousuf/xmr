#!/bin/bash

echo "=== [1/5] Cleaning up ==="
pkill -9 shadps4 2>/dev/null || true
pkill -9 Xorg 2>/dev/null || true

echo "=== [2/5] Setting up 4GB RAM disk ==="
umount /tmp 2>/dev/null || true
rm -rf /tmp/*
mount -t tmpfs -o size=4G tmpfs /tmp

echo "=== [3/5] Mounting GAMES drive (Forced) ==="
umount /mnt/games 2>/dev/null || true
mkdir -p /mnt/games
# Force mount /dev/nvme0n1p6
mount -t ntfs3 -o ro /dev/nvme0n1p6 /mnt/games
if [ $? -ne 0 ]; then
    echo "CRITICAL ERROR: Failed to mount /dev/nvme0n1p6 to /mnt/games!"
    echo "Cannot continue."
    exit 1
fi
echo "Drive mounted successfully."

echo "=== [4/5] Fixing Symlinks ==="
rm -rf /root/.config/shadps4/sys_modules
mkdir -p /root/.config/shadps4
ln -sfn /mnt/games/sys_modules /root/.config/shadps4/sys_modules

# Verify the symlink works before launching
if [ ! -d "/root/.config/shadps4/sys_modules" ]; then
    echo "CRITICAL ERROR: Firmware link is broken. The folder /mnt/games/sys_modules does not exist."
    exit 1
fi

rm -rf /root/.local/share/shadPS4/games
mkdir -p /root/.local/share/shadPS4
ln -sfn /mnt/games/PS4 /root/.local/share/shadPS4/games

echo "=== [5/5] Launching UI ==="
export APPIMAGE_EXTRACT_AND_RUN=1
export XDG_RUNTIME_DIR=/tmp
export QT_QPA_PLATFORM=xcb
export DISPLAY=:0
export __NV_PRIME_RENDER_OFFLOAD=1
export __VK_LAYER_NV_optimus=NVIDIA_only
export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/nvidia_icd.json:/usr/share/vulkan/icd.d/intel_icd.json

xinit /opt/shadps4/shadps4 -b
