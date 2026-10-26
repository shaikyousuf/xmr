cat << 'EOF' > /tmp/qt_launch.sh
#!/bin/bash
export XDG_CONFIG_HOME=/tmp/.config
export XDG_DATA_HOME=/tmp/.local/share
export XDG_RUNTIME_DIR=/tmp
export APPIMAGE_EXTRACT_AND_RUN=1
export QT_QPA_PLATFORM=xcb

openbox &
sleep 2

# Launch the QtLauncher instead of the ImGui UI
/opt/shadps4/shadPS4QtLauncher-qt.AppImage
EOF
chmod +x /tmp/qt_launch.sh
