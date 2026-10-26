cat << 'EOF' > /tmp/run_intel.sh
#!/bin/bash
mkdir -p /mnt/games
if ! mountpoint -q /mnt/games; then
    GAMES_DEV=$(blkid -L GAMES)
    mount -t ntfs3 -o ro "$GAMES_DEV" /mnt/games
fi
mkdir -p /root/.config/shadps4 /root/.local/share/shadPS4
ln -sfn /mnt/games/sys_modules /root/.config/shadps4/sys_modules
ln -sfn /mnt/games/PS4 /root/.local/share/shadPS4/games

export APPIMAGE_EXTRACT_AND_RUN=1
export XDG_RUNTIME_DIR=/tmp
export QT_QPA_PLATFORM=xcb
# Note: NO NVIDIA VARIABLES HERE

xinit /opt/shadps4/shadps4 -b
EOF
chmod +x /tmp/run_intel.sh
/tmp/run_intel.sh
