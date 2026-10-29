# Step 1: Verify the complete 64-bit NVIDIA proprietary rendering layout is in place
echo "[+] Ensuring native NVIDIA runtime pipeline is fully present..."
pacman -S --noconfirm nvidia-utils vulkan-icd-loader

# Step 2: Reconstruct the execution script targeting the discrete GPU layer
cat << 'EOF' > /root/repair_and_launch.sh
#!/bin/bash
# High-Performance Bare-Metal shadPS4 Launch Wrapper (NVIDIA Force-Route)

GAME_PATH="/run/archiso/airootfs/run/archiso/bootmnt/PS4/Limbo_EUR/CUSA01369/eboot.bin"
EMULATOR_BIN="/usr/bin/shadps4"

echo "[+] Constructing explicit X11 execution map targeting NVIDIA Prime offload..."
cat << XINIT > /root/.xinitrc
#!/bin/sh
# Force the Vulkan loader to directly talk only to the NVIDIA proprietary ICD profile
export VK_DRIVER_FILES=/usr/share/vulkan/icd.d/nvidia_icd.json

# Inject complete NVIDIA Prime hardware offload rendering variables
export __NV_PRIME_RENDER_OFFLOAD=1
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export __VK_LAYER_NV_optimus=NVIDIA_only

# Execute the binary wrapper cleanly with explicit boolean tracking strings
exec $EMULATOR_BIN --fullscreen true --game "$GAME_PATH"
XINIT

chmod +x /root/.xinitrc

echo "[+] Spawning dedicated display pipeline on server target :1..."
startx /root/.xinitrc -- :1
EOF

# Step 3: Clear any lingering execution locks and fire the vector
chmod +x /root/repair_and_launch.sh && /root/repair_and_launch.sh
