#!/bin/bash
MOUNT_NAS="//path/to/NAS/Backups/Zomboid";      # Location of NAS to backup to
MOUNT_USER="YOUR_NAS_USERNAME_HERE";            # Nas username
MOUNT_PASS="YOUR_NAS_PASSWORD_HERE";            # Nas Password
MOUNT_LAN="/mnt/backup";                        # Mount NAS to this local folder

# Functions ----------------------------------
function backupFile () {
        echoLog "Backing up '$1'";
        cp "$2" "$MOUNT_LAN/$3"
        echoLog "> Complete"
}
function backupFolder () {
        echoLog "Mirroring '$1'";
        rsync -ric --modify-window=10 --delete $2 $MOUNT_LAN/$3
        #rsync -ri --modify-window=1000 --dry-run --delete $2 $MOUNT_LAN/$3
}
function compressFolder() {
        echoLog "Compressing Folder";
        echoLog "> From: '$1'";
        echoLog "> To:   '$2'";
        rm $2
        #Absolute Path in Zip
        tar -zcvf "$2" "$1" > /dev/null
        #Relative Paths in Zip
        #tar -zcvf "$2" -C "$1" "$1" > /dev/null
        echoLog ">> Success"
        sync;
}
function echoLog () {
         echo "[$(date +%H:%M:%S)] $1";
}

# Routine ------------------------------------
#0: Should be run as root
if [[ $EUID -ne 0 ]]; then
        echo "THIS SHOULD BE RUN AS ROOT"
        echo "sudo ./$(basename "$0")";
        exit
fi

#1: Mount NAS
echoLog "Mounting NAS..."
mount -t cifs $MOUNT_NAS $MOUNT_LAN -o username=$MOUNT_USER,password=$MOUNT_PASS,vers=3.0 > /dev/null
if ! grep -qs "$MOUNT_LAN" /proc/mounts; then
        echoLog ">> Mount Failure! Aborting..."
        exit 1;
fi

#2: Create a World Backup in a compressed format
#   Zomboid uses a ridiculous amount of individual small files to record world state
compressFolder "/home/steam/Zomboid/Saves/Multiplayer/servertest/"  "/home/steam/world-backup.tar.gz"
backupFile     "Zomboid: World"   "/home/steam/world-backup.tar.gz" "Zomboid/world-backup.tar.gz"
rm "/home/steam/world-backup.tar.gz"

#3: Run Other Backups
#Folder/File    Name                Local Path                                              Remote Path (relative)
backupFolder    "System: Scripts"  "/home/steam/scripts/"                                   "scripts"
backupFolder    "System: Logs"     "/home/steam/logs/"                                      "logs"
backupFile      "System: Notes"    "/home/steam/notes.txt"                                  "notes.txt"
backupFolder    "Zomboid: db"      "/home/steam/Zomboid/db/"                                "Zomboid/db"
backupFolder    "Zomboid: Logs"    "/home/steam/Zomboid/Logs/"                              "Zomboid/Logs"
backupFolder    "Zomboid: Server"  "/home/steam/Zomboid/Server/"                            "Zomboid/Server"
backupFile      "Zomboid: Option"  "/home/steam/Zomboid/options.ini"                        "Zomboid/options.ini"
backupFile      "Zomboid: Console" "/home/steam/Zomboid/server-console.txt"                 "Zomboid/server-console.txt"
backupFolder    "Zomboid: Mods"    "/home/steam/zomboid/steamapps/workshop/content/108600/" "mods"

#4: Backup Crontab
echoLog "Creating Cronjob Backup...";
crontab -l > $MOUNT_LAN/cronjob.bak
echoLog "> Complete";

#5: Dismount NAS
echoLog "Dismounting NAS";
umount $MOUNT_NAS > /dev/null
echoLog "> Complete";

#Done
