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
#Should be run as root
if [[ $EUID -eq 0 ]]; then
        echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        echo "!! DO NOT RUN THIS AS ROOT !!"
        echo "!! DO NOT RUN THIS AS ROOT !!"
        echo "!! DO NOT RUN THIS AS ROOT !!"
        echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        echo "This should be run as the 'steam' account"
        echo "sudo -u steam ./$(basename "$0")";
        exit
fi

drawLine
echo "$(date)"
drawLine
drawHeader 1 3 "Stopping Zomboid server"
echo "> Sending 5 second warning"
cd /home/steam/scripts
sudo -u steam /home/steam/scripts/includes/message.sh "Going down for updates in 5 seconds"
sleep 5
echo "> Running /includes/stop.sh"
sudo -u steam /home/steam/scripts/includes/stop.sh
echo ">> Done. Sleeping 10 seconds"
sleep 10
echo ">>> Done"
drawLine

drawHeader 2 3 "Updating Zomboid"
sudo -u steam /home/steam/scripts/includes/update.sh
echo ">> Done."
sleep 5
drawLine

drawHeader 3 3 "Starting Zomboid server"
echo "> Running /includes/start.sh"
cd /home/steam/scripts
sudo -u steam /home/steam/scripts/includes/start.sh
echo ">> Done"
sleep 3