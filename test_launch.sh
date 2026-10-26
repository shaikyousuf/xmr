#!/bin/bash

echo "=== [1/6] Cleaning up old processes and configs ==="
pkill -9 shadps4 2>/dev/null || true
pkill -9 Xorg 2>/dev/null || true
pkill -9 openbox 2>/dev/null || true
rm -rf /root/.config/shadps4 /root/.local/share/shadPS4 /tmp/.config /tmp/.local

echo "=== [2/6] Setting up 4GB RAM disk ==="
umount /tmp 2>/dev/null || true
rm -rf /tmp/*
mount -t tmpfs -o size=4G tmpfs /tmp

echo "=== [3/6] Mounting GAMES drive ==="
umount /mnt/games 2>/dev/null || true
mkdir -p /mnt/games
mount -t ntfs3 -o ro /dev/nvme0n1p6 /mnt/games

echo "=== [4/6] Copying Firmware & Linking Games ==="
mkdir -p /tmp/.config/shadps4/sys_modules
cp -r /mnt/games/sys_modules/* /tmp/.config/shadps4/sys_modules/ 2>/dev/null

mkdir -p /tmp/.local/share/shadPS4
ln -sfn /mnt/games/PS4 /tmp/.local/share/shadPS4/games

echo "=== [5/6] Writing config.toml (Bypasses File Picker) ==="
# THIS IS THE MAGIC LINE THAT FIXES THE FILE PICKER
echo -e "[General]\nFullscreen = true\n\n[GUI]\ngamedirs = [\"/tmp/.local/share/shadPS4/games\"]" > /tmp/.config/shadps4/config.toml

echo "=== [6/6] Launching UI ==="
cat << 'EOF' > /tmp/run_ui.sh
#!/bin/bash
export XDG_CONFIG_HOME=/tmp/.config
export XDG_DATA_HOME=/tmp/.local/share
export XDG_RUNTIME_DIR=/tmp
export APPIMAGE_EXTRACT_AND_RUN=1
export QT_QPA_PLATFORM=xcb

# Start Window Manager
openbox &
sleep 2

# Start shadPS4
/opt/shadps4/shadps4 -b
EOF

chmod +x /tmp/run_ui.sh
xinit /tmp/run_ui.sh
