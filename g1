cat << 'EOF' >> /mnt/games/LIVE_BOOT_STATE1.txt

======================================================
[17] FINAL CRYPTOGRAPHIC & STRUCTURAL CHECKS
======================================================

--- A. EXACT APPIMAGE HASH ---
EOF
sha256sum /opt/shadps4/shadps4 >> /mnt/games/LIVE_BOOT_STATE.txt 2>&1

echo -e "\n--- B. GAME DIRECTORY TREE (Deep Scan) ---" >> /mnt/games/LIVE_BOOT_STATE.txt
find /mnt/games/PS4 -maxdepth 2 -type f >> /mnt/games/LIVE_BOOT_STATE.txt 2>&1

echo -e "\n--- C. SCE_SYS FOLDER CONTENTS ---" >> /mnt/games/LIVE_BOOT_STATE.txt
ls -la /mnt/games/PS4/sce_sys/ >> /mnt/games/LIVE_BOOT_STATE.txt 2>&1

echo -e "\n--- D. EXACT KERNEL VERSION (To match headers in WSL) ---" >> /mnt/games/LIVE_BOOT_STATE.txt
uname -r >> /mnt/games/LIVE_BOOT_STATE.txt 2>&1

echo "======================================================"
echo "FINAL EXTRACTION COMPLETE. FILE SIZE:"
ls -la /mnt/games/LIVE_BOOT_STATE1.txt
