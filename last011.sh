cat << 'EOF' > /root/run_sdl.sh
#!/bin/bash

# 1. Create the missing folders
mkdir -p /tmp/.config/shadps4/sys_modules
mkdir -p /tmp/.local/share/shadPS4

# 2. Copy firmware if it's not there
if [ -d "/mnt/games/sys_modules" ]; then
    cp -r /mnt/games/sys_modules/* /tmp/.config/shadps4/sys_modules/ 2>/dev/null
fi

# 3. Set variables
export XDG_CONFIG_HOME=/tmp/.config
export XDG_DATA_HOME=/tmp/.local/share
export XDG_RUNTIME_DIR=/tmp
export APPIMAGE_EXTRACT_AND_RUN=1
export QT_QPA_PLATFORM=xcb

openbox &
sleep 2

# 4. Launch the game
/opt/shadps4/shadps4 --game /mnt/games/PS4/eboot.bin
EOF
chmod +x /root/run_sdl.sh
