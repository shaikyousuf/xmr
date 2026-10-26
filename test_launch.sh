#!/bin/bash

echo "=== [1/7] Cleaning up old processes ==="
pkill -9 shadps4 2>/dev/null || true
pkill -9 Xorg 2>/dev/null || true

echo "=== [2/7] Fixing Input Drivers (Keyboard/Mouse) ==="
mkdir -p /etc/X11/xorg.conf.d
cat <<EOF > /etc/X11/xorg.conf.d/10-libinput.conf
Section "InputClass"
    Identifier "libinput pointer catchall"
    MatchIsPointer "on"
    MatchDevicePath "/dev/input/event*"
    Driver "libinput"
EndSection

Section "InputClass"
    Identifier "libinput keyboard catchall"
    MatchIsKeyboard "on"
    MatchDevicePath "/dev/input/event*"
    Driver "libinput"
EndSection

Section "InputClass"
    Identifier "libinput touchpad catchall"
    MatchIsTouchpad "on"
    MatchDevicePath "/dev/input/event*"
    Driver "libinput"
EndSection
EOF

echo "=== [3/7] Setting up 4GB RAM disk for /tmp ==="
umount /tmp 2>/dev/null || true
rm -rf /tmp/*
mount -t tmpfs -o size=4G tmpfs /tmp

echo "=== [4/7] Mounting GAMES drive ==="
umount /mnt/games 2>/dev/null || true
mkdir -p /mnt/games
mount -t ntfs3 -o ro /dev/nvme0n1p6 /mnt/games
if [ ! -d "/mnt/games/sys_modules" ]; then
    echo "CRITICAL ERROR: /mnt/games/sys_modules is missing!"
    exit 1
fi

echo "=== [5/7] Copying Firmware & Linking Games ==="
# Copy firmware to /tmp (bypasses sandbox)
rm -rf /tmp/.config/shadps4
mkdir -p /tmp/.config/shadps4/sys_modules
cp -r /mnt/games/sys_modules/* /tmp/.config/shadps4/sys_modules/
echo "Firmware files: $(ls /tmp/.config/shadps4/sys_modules/ | wc -l)"

# Link games
rm -rf /tmp/.local/share/shadPS4
mkdir -p /tmp/.local/share/shadPS4
ln -sfn /mnt/games/PS4 /tmp/.local/share/shadPS4/games

echo "=== [6/7] Setting Environment Variables ==="
# CRITICAL: Use XDG variables instead of HOME to keep Xorg inputs alive
export XDG_CONFIG_HOME=/tmp/.config
export XDG_DATA_HOME=/tmp/.local/share
export XDG_RUNTIME_DIR=/tmp
export APPIMAGE_EXTRACT_AND_RUN=1
export QT_QPA_PLATFORM=xcb
export DISPLAY=:0

# Check if NVIDIA driver is loaded. If yes, force offload. If no, let system fallback.
if lsmod | grep -q "^nvidia"; then
    echo "NVIDIA driver detected. Forcing PRIME Offload..."
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __VK_LAYER_NV_optimus=NVIDIA_only
    export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/nvidia_icd.json:/usr/share/vulkan/icd.d/intel_icd.json
else
    echo "NVIDIA driver NOT detected. Using default graphics..."
    export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/intel_icd.json:/usr/share/vulkan/icd.d/nouveau_icd.json
fi

echo "=== [7/7] Launching UI ==="
xinit /opt/shadps4/shadps4 -b

echo "=================================================="
echo "UI CLOSED. HERE IS THE FRESH LOG:"
echo "=================================================="
cat /tmp/.local/share/shadPS4/log/shadps4.log 2>/dev/null || echo "Log file not found."
