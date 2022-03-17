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

drawLine
echo "$(date)"
drawLine
drawHeader 1 2 "Updating Zomboid & Mods"
cd /home/steam/zomboid
sudo -u steam /home/steam/scripts/includes/update.sh
sleep 1
drawLine

drawHeader 2 2 "Starting Zomboid Server"
cd /home/steam/zomboid
sudo -u steam /home/steam/scripts/includes/start.sh
/usr/bin/screen -ls

drawLine
echo "$(date)"