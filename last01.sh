cat << 'EOF' > /root/run_sdl.sh
#!/bin/bash
export XDG_CONFIG_HOME=/tmp/.config
export XDG_DATA_HOME=/tmp/.local/share
export XDG_RUNTIME_DIR=/tmp
export APPIMAGE_EXTRACT_AND_RUN=1
export QT_QPA_PLATFORM=xcb

openbox &
sleep 2

# Launch the 33MB SDL AppImage directly with the game
/opt/shadps4/shadps4 --game /mnt/games/PS4/eboot.bin
EOF
chmod +x /root/run_sdl.sh
