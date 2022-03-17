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

rm /home/steam/logs/monitor.log
touch /home/steam/logs/monitor.log

drawLine
echo "$(date)"
drawLine
drawHeader 1 3 "Waiting for System startup"
echo "> Sleeping for 10 seconds"
sleep 10
echo ">> Done!"

drawHeader 2 3 "Updating Zomboid & Mods"
cd /home/steam/zomboid
sudo -u steam /home/steam/scripts/includes/update.sh
sleep 5
drawLine

drawHeader 3 3 "Starting Zomboid Server"
cd /home/steam/zomboid
sudo -u steam /home/steam/scripts/includes/start.sh
/usr/bin/screen -ls

drawLine
echo "$(date)"