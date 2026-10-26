Xorg :0 &
sleep 2
export DISPLAY=:0 XDG_CONFIG_HOME=/tmp/.config XDG_DATA_HOME=/tmp/.local/share APPIMAGE_EXTRACT_AND_RUN=1 QT_QPA_PLATFORM=xcb
/opt/shadps4/shadps4 --game /mnt/games/PS4/eboot.bin
