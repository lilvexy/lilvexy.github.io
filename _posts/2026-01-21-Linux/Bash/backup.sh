gggggggggf#!/bin/bash
Backups="/home/Shared_DA" #variabel för foldern som ska backasup
LocationBup="/home/ella/projectbackup" # plats där backup sparas
logfile="/home/ella/projectbackup/backup.log" #loggan 
# === Skapa backupmapp om den inte finns ===
mkdir -p "$Backups"  #skapar foldern.
DATE=$(date +'%Y-%m-%d_%H-%M-%S')  # anger hur date ska visas.

tar -czf "$LocationBup/backup_$DATE.tar.gz" "$Backups"  # skapar en komprimerad fil av mappen med datum i namnet. 

echo "[$(date)] Backup skapad: projectbackup_$DATE.tar.gz" >> "$logfile" #skriver ut till terminal datum backup skapad projecktbackupdatum.tar.gz så får man loggat att komprimerade filen är sparad
# == Radera backupfiler äldre än 7 dagar ==
find "$LocationBup" -type f -name "projectbackup_*.tar.gz" -mtime +7 -exec rm {} \;   #söker location anger fil och namn som börjar på projectbackup_ -modification time +7 innebär 7 dagar sedan ändring och då executas rm cmdn.
