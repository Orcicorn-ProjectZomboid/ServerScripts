#!/bin/bash
cd /home/steam/zomboid
echo "Stopping the Server...."
sudo -u steam /home/steam/scripts/includes/message.sh "Server is stopping"
sleep 3;
sudo -u steam /home/steam/scripts/includes/stop.sh
echo "> Done"