#!/bin/bash
cd /home/steam/zomboid

echo "Starting the Server..."
sudo -u steam /home/steam/scripts/includes/start.sh
echo "> Done"
echo ""

echo "Screens:"
sudo -u steam /usr/bin/screen -ls