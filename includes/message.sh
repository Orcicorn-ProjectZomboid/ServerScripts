#!/bin/bash
cd /home/steam/zomboid
message="servermsg \"$1\"\n"
echo "Sending: \"$message\""
sudo -u steam /usr/bin/screen -x zomboid -X stuff "$message"
