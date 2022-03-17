#!/bin/bash
function drawLine () {
        echo "=================================================="
}
function drawHeader () {
        echo ""
        drawLine
        echo -e " [$1/$2] $3"
        drawLine
}
if [[ $EUID -ne 0 ]]; then
        drawHeader 1 1 "ERROR!"
        echo " This script should be run as a root user"
        echo " sudo ./$(basename "$0")";
        drawLine
        exit
fi

drawLine
echo "$(date)"
drawLine
drawHeader 1 4 "Stopping Zomboid"
cd /home/steam/scripts
sudo -u steam /home/steam/scripts/includes/stop.sh
sleep 10

drawHeader 2 4 "Backing up Zomboid"
cd /home/steam/scripts
source backup.sh
sleep 5

drawHeader 3 4 "Cleaning up Disk"
echo "Sync disk changes"
sync
sleep 3
echo "Trim Disk"
fstrim -v --all
sleep 1
echo "Sync disk changes"
sync
sleep 3

drawHeader 4 4 "Shutting down"
echo "Shutting down in 10 seconds"
echo "Ctrl+C to abort"
sleep 10
echo "Goodbye!"
drawLine
echo "$(date)"
drawLine
sleep 1

su -c 'shutdown -h now'