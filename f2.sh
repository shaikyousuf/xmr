cat << 'EOF' > /mnt/games/LIVE_BOOT_STATE.txt
======================================================
LIVE USB STATE REPORT - SHADPS4 CONSOLE
======================================================

[1] WHY THE LIVE TEST FAILED (HARDWARE LIMITATION)
- Error: "Device lost during submit!" (Vulkan crash)
- Reason: The GTX 1050 is asleep. This Live ISO is missing the nvidia-580xx-dkms package.
- The Intel iGPU tried to render 3D graphics for Limbo and crashed.

[2] PACKAGES MANUALLY INSTALLED ON LIVE USB
- fuse2 (Required for AppImages)
- xf86-input-libinput (Required for keyboard/mouse)
- openbox (Window manager for focus)
- xdotool (Used for scripting)

[3] THE EXACT XORG INPUT CONFIG (/etc/X11/xorg.conf.d/10-libinput.conf)
EOF
cat /etc/X11/xorg.conf.d/10-libinput.conf >> /mnt/games/LIVE_BOOT_STATE.txt

echo -e "\n[4] THE FINAL LAUNCH SCRIPT (/root/run_sdl.sh)" >> /mnt/games/LIVE_BOOT_STATE.txt
cat /root/run_sdl.sh >> /mnt/games/LIVE_BOOT_STATE.txt

echo -e "\n[5] GAME DIRECTORY STRUCTURE (/mnt/games/PS4)" >> /mnt/games/LIVE_BOOT_STATE.txt
ls -la /mnt/games/PS4/ >> /mnt/games/LIVE_BOOT_STATE.txt

echo -e "\n[6] MISSING GAME FILES DETECTED BY EMULATOR" >> /mnt/games/LIVE_BOOT_STATE.txt
echo "The eboot.bin requested: libbo_boot.pkgps4, settings.txt, textures/white.png" >> /mnt/games/LIVE_BOOT_STATE.txt
echo "These were NOT found in the game folder. The game dump is incomplete." >> /mnt/games/LIVE_BOOT_STATE.txt

echo -e "\n[7] VULKAN STATUS" >> /mnt/games/LIVE_BOOT_STATE.txt
vulkaninfo --summary >> /mnt/games/LIVE_BOOT_STATE.txt 2>&1

echo "======================================================"
echo "REPORT GENERATED SUCCESSFULLY."
echo "Saved to: /mnt/games/LIVE_BOOT_STATE.txt"
echo "======================================================"
EOF
