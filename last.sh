#!/bin/bash

echo "=== [1/6] Stopping stuck processes ==="
pkill -9 shadps4 2>/dev/null || true
pkill -9 Xorg 2>/dev/null || true
pkill -9 openbox 2>/dev/null || true

echo "=== [2/6] Setting up 4GB RAM disk ==="
umount /tmp 2>/dev/null || true
rm -rf /tmp/*
mount -t tmpfs -o size=4G tmpfs /tmp

echo "=== [3/6] Mounting GAMES drive ==="
umount /mnt/games 2>/dev/null || true
mkdir -p /mnt/games
mount -t ntfs3 -o ro /dev/nvme0n1p6 /mnt/games

echo "=== [4/6] Copying Firmware ==="
mkdir -p /tmp/.config/shadps4/sys_modules
cp -r /mnt/games/sys_modules/* /tmp/.config/shadps4/sys_modules/ 2>/dev/null
echo "Firmware files copied: $(ls /tmp/.config/shadps4/sys_modules/ | wc -l)"

echo "=== [5/6] Creating Direct-Boot Launcher ==="
cat << 'EOF' > /tmp/direct_boot.sh
#!/bin/bash
export XDG_CONFIG_HOME=/tmp/.config
export XDG_DATA_HOME=/tmp/.local/share
export XDG_RUNTIME_DIR=/tmp
export APPIMAGE_EXTRACT_AND_RUN=1
export QT_QPA_PLATFORM=xcb

# Start Window Manager to handle drawing the game window
openbox &
sleep 2

# Run shadPS4 DIRECTLY with the game path
/opt/shadps4/shadps4 --game /mnt/games/PS4/eboot.bin
EOF
chmod +x /tmp/direct_boot.sh

echo "=== [6/6] Launching Game ==="
xinit /tmp/direct_boot.sh
