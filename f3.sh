cat << 'EOF' >> /mnt/games/LIVE_BOOT_STATE.txt

======================================================
[16] ARCHITECTURAL MANIFEST: EXACT FILE PERMISSIONS & STRUCTURE
======================================================

--- A. X11 & SYSTEMD CONFIGURATIONS ---
EOF
ls -laR /etc/X11 >> /mnt/games/LIVE_BOOT_STATE.txt 2>&1
ls -laR /etc/systemd/system >> /mnt/games/LIVE_BOOT_STATE.txt 2>&1
ls -laR /etc/ssh >> /mnt/games/LIVE_BOOT_STATE.txt 2>&1

echo -e "\n--- B. ROOT USER SCRIPTS & CONFIGS (The Launchpad) ---" >> /mnt/games/LIVE_BOOT_STATE.txt
ls -laR /root >> /mnt/games/LIVE_BOOT_STATE.txt 2>&1

echo -e "\n--- C. OPT & LOCAL BIN (The Emulator) ---" >> /mnt/games/LIVE_BOOT_STATE.txt
ls -laR /opt/shadps4 >> /mnt/games/LIVE_BOOT_STATE.txt 2>&1
ls -laR /usr/local/bin >> /mnt/games/LIVE_BOOT_STATE.txt 2>&1

echo -e "\n--- D. SYSTEM MOUNTS & RAM DISK ---" >> /mnt/games/LIVE_BOOT_STATE.txt
df -h >> /mnt/games/LIVE_BOOT_STATE.txt 2>&1
mount | grep -E "tmpfs|ntfs|ext4" >> /mnt/games/LIVE_BOOT_STATE.txt 2>&1

echo -e "\n--- E. ACTIVE SYSTEMD SERVICES (What succeeded) ---" >> /mnt/games/LIVE_BOOT_STATE.txt
systemctl list-units --type=service --state=running >> /mnt/games/LIVE_BOOT_STATE.txt 2>&1

echo -e "\n--- F. GAME DIRECTORY STRUCTURE ---" >> /mnt/games/LIVE_BOOT_STATE.txt
ls -la /mnt/games/PS4/ >> /mnt/games/LIVE_BOOT_STATE.txt 2>&1

echo "======================================================"
echo "MANIFEST COMPLETE. FILE SIZE:"
ls -la /mnt/games/LIVE_BOOT_STATE.txt
