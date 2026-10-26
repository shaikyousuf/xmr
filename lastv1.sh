#!/bin/bash

echo "=== [1/6] Cleaning up ==="
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

echo "=== [4/6] Copying Game & Renaming Files ==="
mkdir -p /tmp/game_test
cp -r /mnt/games/PS4/* /tmp/game_test/ 2>/dev/null || true

# Rename the files from limbo_ to libbo_
if [ -f "/tmp/game_test/limbo_boot.pkgps4" ]; then
    mv /tmp/game_test/limbo_boot.pkgps4 /tmp/game_test/libbo_boot.pkgps4
fi
if [ -f "/tmp/game_test/limbo_runtime.pkgps4" ]; then
    mv /tmp/game_test/limbo_runtime.pkgps4 /tmp/game_test/libbo_runtime.pkgps4
fi

echo "=== [5/6] Copying Firmware & Creating Configs ==="
mkdir -p /tmp/.config/shadps4/sys_modules
cp -r /mnt/games/sys_modules/* /tmp/.config/shadps4/sys_modules/ 2>/dev/null || true

# Create the config folder that crashed last time
mkdir -p /tmp/.local/share/shadPS4
echo -e "[General]\nFullscreen = true\n\n[GUI]\ngamedirs = [\"/tmp/game_test\"]" > /tmp/.config/shadps4/config.toml

echo "=== [6/6] Launching Game Directly ==="
cat << 'EOF' > /tmp/run_game.sh
#!/bin/bash
export XDG_CONFIG_HOME=/tmp/.config
export XDG_DATA_HOME=/tmp/.local/share
export XDG_RUNTIME_DIR=/tmp
export APPIMAGE_EXTRACT_AND_RUN=1
export QT_QPA_PLATFORM=xcb

# Start window manager for focus
openbox &
sleep 2

# Launch directly from the RAM disk copy
/opt/shadps4/shadps4 --game /tmp/game_test/eboot.bin
EOF
chmod +x /tmp/run_game.sh

xinit /tmp/run_game.sh
