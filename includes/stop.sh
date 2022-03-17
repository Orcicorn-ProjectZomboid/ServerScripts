#!/bin/bash
cd /home/steam/zomboid
sudo -u steam /usr/bin/screen -x zomboid -X stuff 'servermsg "Server is stopping"\n'
sudo -u steam /usr/bin/screen -x zomboid -X stuff "save\n"
sleep 5
sudo -u steam /usr/bin/screen -x zomboid -X stuff "quit\n"
sleep 10
