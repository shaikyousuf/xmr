# 1. Setup RAM disk and Mount Drive
umount /tmp 2>/dev/null; mount -t tmpfs -o size=4G tmpfs /tmp
umount /mnt/games 2>/dev/null; mount -t ntfs3 -o ro /dev/nvme0n1p6 /mnt/games

# 2. Delete old configs to prevent the popup entirely
rm -rf /root/.config/shadps4 /root/.local/share/shadPS4 /tmp/.config /tmp/.local

# 3. Copy Firmware
mkdir -p /tmp/.config/shadps4/sys_modules
cp -r /mnt/games/sys_modules/* /tmp/.config/shadps4/sys_modules/
mkdir -p /tmp/.local/share/shadPS4
ln -sfn /mnt/games/PS4 /tmp/.local/share/shadPS4/games

# 4. Create the Launcher
cat << 'EOF' > /tmp/launch.sh
#!/bin/bash
export XDG_CONFIG_HOME=/tmp/.config
export XDG_DATA_HOME=/tmp/.local/share
export XDG_RUNTIME_DIR=/tmp
export APPIMAGE_EXTRACT_AND_RUN=1
export QT_QPA_PLATFORM=xcb

# Start Openbox (Window Manager) to handle inputs/focus
openbox &
sleep 2

# Launch shadPS4
/opt/shadps4/shadps4 -b
EOF
chmod +x /tmp/launch.sh

# 5. Launch!
xinit /tmp/launch.sh
