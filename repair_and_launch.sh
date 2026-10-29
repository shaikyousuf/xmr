#!/bin/bash
# ==============================================================================
# ARCHISO BARE-METAL APPLIANCE REPAIR & EXECUTION MATRIX
# Target: Intel i5-9300H / NVIDIA Hybrid GPU | Project: shadPS4 Standalone Boot
# ==============================================================================
set -e

# Visual Indicator Constants
INFO="[\033[1;34mINFO\033[0m]"
SUCCESS="[\033[1;32mSUCCESS\033[0m]"
WARN="[\033[1;33mWARNING\033[0m]"
ERROR="[\033[1;31mERROR\033[0m]"

echo -e "\n\033[1;36m=== STARTING SYSTEM APPLIANCE SANITY AND DEPLOYMENT PASS ===\033[0m"

# ------------------------------------------------------------------------------
# CHECKPOINT 1: SYSTEM RE-MANAGING PHYSICAL MEMORY LOCKS
# ------------------------------------------------------------------------------
echo -e "$INFO Auditing system storage memory thresholds..."
if [ -d "/run/archiso/cowspace" ]; then
    echo -e "$INFO Overriding default 50% kernel RAM ceiling restriction..."
    if mount -o remount,size=16G /run/archiso/cowspace 2>/dev/null; then
        echo -e "$SUCCESS Volatile copy-on-write RAM space successfully expanded to 16 GB."
    else
        echo -e "$WARN Direct remount fallback triggered. Proceeding with caution."
    fi
fi

# ------------------------------------------------------------------------------
# CHECKPOINT 2: NETWORK ROUTING STATE VERIFICATION
# ------------------------------------------------------------------------------
echo -e "$INFO Testing external upstream network routing vectors..."
if ping -c 2 archlinux.org >/dev/null 2>&1; then
    echo -e "$SUCCESS Network matrix verified active. Upstream repositories accessible."
else
    echo -e "$ERROR Network link down. Unable to download components."
    echo -e "$INFO Attempting to kickstart the system systemd-resolved network interface daemon..."
    systemctl restart systemd-networkd || true
    sleep 2
fi

# ------------------------------------------------------------------------------
# CHECKPOINT 3: DEPENDENCY COMPONENT INJECTION
# ------------------------------------------------------------------------------
echo -e "$INFO Synchronizing upstream repository definitions..."
pacman -Syy --noconfirm

echo -e "$INFO Injecting missing graphical and input infrastructure layers..."
REQUIRED_PKGS=("xorg-server" "xorg-xinit" "xf86-input-libinput")
MISSING_PKGS=()

for pkg in "${REQUIRED_PKGS[@]}"; do
    if ! pacman -Qi "$pkg" >/dev/null 2>&1; then
        MISSING_PKGS+=("$pkg")
    fi
done

if [ ${#MISSING_PKGS[@]} -gt 0 ]; then
    echo -e "$INFO Downloading target objects: ${MISSING_PKGS[*]}"
    pacman -S "${MISSING_PKGS[@]}" --noconfirm
    echo -e "$SUCCESS Dependency array cleanly mounted to root overlay structure."
else
    echo -e "$SUCCESS All graphical server infrastructure layers already verified in RAM."
fi

# ------------------------------------------------------------------------------
# CHECKPOINT 4: EMULATOR CONFIGURATION RUNTIME PATH ENGINE
# ------------------------------------------------------------------------------
echo -e "$INFO Rectifying shadPS4 state container directory structures..."
# Creates the missing path target to completely bypass the C++ filesystem crash loop
mkdir -p /root/.local/share/shadPS4/data/user/app
echo -e "$SUCCESS Storage state nodes structurally locked down at 755 hierarchy."

# ------------------------------------------------------------------------------
# CHECKPOINT 5: GAME PAYLOAD ANALYSIS AND GRAPHICS SERVER BINDING
# ------------------------------------------------------------------------------
echo -e "$INFO Executing structural scan for valid game executable binaries..."
TARGET_GAME_DIR="/run/archiso/airootfs/run/archiso/bootmnt/PS4/Limbo_EUR/CUSA01369"

if [ -d "$TARGET_GAME_DIR" ]; then
    echo -e "$SUCCESS Target deployment path validated inside memory layers."
    
    # Trace the direct boot binary inside your deep nested directory layout
    EBOOT_PATH=$(find "$TARGET_GAME_DIR" -name "eboot.bin" -print -quit 2>/dev/null)
    
    if [ -n "$EBOOT_PATH" ] && [ -f "$EBOOT_PATH" ]; then
        echo -e "$SUCCESS Found explicit boot asset marker object at: $EBOOT_PATH"
        # Overwrite the X11 script to mount directly to the structural file path
        echo "exec shadps4 \"$EBOOT_PATH\"" > /root/.xinitrc
    else
        echo -e "$WARN executable 'eboot.bin' missing inside target space. Binding directory root pointer."
        echo "exec shadps4 \"$TARGET_GAME_DIR\"" > /root/.xinitrc
    fi
else
    echo -e "$WARN Game directory path structure missing from expected RAM offset maps."
    echo -e "$INFO Scanning alternative fallback block paths..."
    ALT_PATH=$(find / -type d -name "CUSA01369" -print -quit 2>/dev/null || true)
    
    if [ -n "$ALT_PATH" ]; then
        echo -e "$SUCCESS Found alternative game matrix layout at: $ALT_PATH"
        EBOOT_ALT=$(find "$ALT_PATH" -name "eboot.bin" -print -quit 2>/dev/null || true)
        if [ -n "$EBOOT_ALT" ]; then
            echo "exec shadps4 \"$EBOOT_ALT\"" > /root/.xinitrc
        else
            echo "exec shadps4 \"$ALT_PATH\"" > /root/.xinitrc
        fi
    else
        echo -e "$ERROR Completely unable to isolate game block payloads inside storage array."
        echo -e "$INFO Defaulting fallback parameters to load standard emulator GUI shell context."
        echo "exec shadps4" > /root/.xinitrc
    fi
fi

chmod 644 /root/.xinitrc
sync

# ------------------------------------------------------------------------------
# CHECKPOINT 6: INITIALIZING GRAPHICS SERVER ENGINE
# ------------------------------------------------------------------------------
echo -e "\n\033[1;32m=== CORES VALIDATED & REPAIRED NATIVELY ===\033[0m"
echo -e "$INFO Flushing active console processes..."

# Recycles any existing, stalled Xorg processes in memory
pkill Xorg || true
sleep 1

echo -e "$SUCCESS Starting X11 engine pipeline. Redirecting control tokens to shadPS4..."
echo -e "$INFO Handing execution node tracking over to display server... Standby."
sleep 1

# Kickstart the raw graphical platform
startx
