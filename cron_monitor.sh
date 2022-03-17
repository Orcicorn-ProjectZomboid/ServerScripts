#!/bin/bash

#Configurations
cmd_screen="pgrep screen";
cmd_steam="pgrep steamcmd";
cmd_zomboid="pgrep ProjectZomboid";
script_update="/home/steam/scripts/cron_update.sh"
sleep=10
testcount=0;
mid=""

# Functions
function print() {
        time=`date +"%T"`
        echo "[${time}] $1"
}


# Logic
while [ $testcount -lt 2 ]; do
        print "Checking Server Status"
        if [ -z $($cmd_screen) ]; then
                print "> Screen is$mid down"
                if [ -z $($cmd_steam) ]; then
                        print "> Steam is$mid down"
                        if [ $testcount -eq 0 ]; then
                                print ">> Retest in $sleep seconds"
                                print "!!!!!!!!!!!!!!!!!!!!!!!!!!!"
                                testcount=1;
                                mid=" still"
                                sleep $sleep;
                        else
                                print "> Running Steam Updater"
                                source $script_update;
                                break;
                        fi
                else
                        print "> Steam is running"
                        break
                fi
        else
                print "> Screen is running"
                break
        fi
done