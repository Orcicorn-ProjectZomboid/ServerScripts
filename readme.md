# Zomboid Server Scripts
The following collection of scripts are used to monitor, manage and update the Project Zomboid Server for the private Space Brothers group.

Some terminology used below is as follows:
- **Server**: The physical machine running all of these processes
- **Zomboid Server**: The Project Zomboid server executeable that powers the game

Caveats:
- Assumes the user account is called `steam`
- Assumes the scripts are located in `/home/steam/scripts/`
- Assumes `screen` and `steamcmd` has already been installed

## Manually run task scripts
These are a series of scripts/commands that are created for a human to manually trigger and tell the server which actions to take.

They are expected to be run under the proper user account and **not** as the root/admin.

| Script | Purpose |
| ------------ | ------------ |
| `server-restart.sh` | Stops then starts the Zomboid server |
| `server-start.sh` | Starts the Zomboid server |
| `server-stop.sh` | Stops the Zomboid server |
| `server-update.sh` | Stops Zomboid server, runs steam updates, runs workshop updates then starts the server |

## Scheduled task scripts
These are a series of scripts that are setup using the server's cronjobs as a scheduled task. For example the cron_monitor may run every minute while the shutdown may only trigger at 2am.

These are expected to be run as the system account and should not be run manually by the user.

| Script | Purpose |
| ------------ | ------------ |
| `cron_monitor.sh` | Runs every minute to ensure that Zomboid is running and restart it if it is not. |
| `cron_shutdown.sh` | Shuts the zomboid server down at the end of the night, runs backups and powers off |
| `cron_startup.sh` | Triggers on physical server boot to start the Zomboid application |
| `cron_update.sh` | Updates Zomboid through steam, all of it's mods through workshop and then starts server |

Big advantage to the `cron_monitor.sh` is that we can now  use [UpdatePlz](https://steamcommunity.com/sharedfiles/filedetails/?id=2779169728) which shuts the server down when the workshop is out of date and no players are connected. `cron_monitor.sh` will then restart and update the server after it has finished powering off

## Includes used in the above tasks
These *partials* are used within all the above scripts. Rather than type out the same commands over and over they have been written once to a file and then included in the above scripts.

For example, the `server-restart.sh` script actually includes the stop, update and start includes.

| Script | Purpose |
| ------------ | ------------ |
| `/includes/message.sh` | Sends an in-game message to all players |
| `/includes/start.sh` | Starts the Zomboid Server |
| `/includes/stop.sh` | Stops the Zomboid Server |
| `/includes/update.sh` | Updates the Zomboid Server software |

## Cron
```bash
MAILTO=""
# ==============================================
# PROJECT ZOMBOID SERVER SOFTWARE --------------
#       On startup      Start the Zomboid Server after 10 seconds
#       09:00-23:00     Make sure the server is running, restart if needed
#       01:45           Stop Zomboid, Backup and Shutdown System
# ==============================================
@reboot sudo -u steam "/home/steam/scripts/cron_startup.sh" > /home/steam/logs/autostart.log
* 9-23 * * * /home/steam/scripts/cron_monitor.sh >> /home/steam/logs/monitor.log
45  1 * * * /home/steam/scripts/cron_shutdown.sh > /home/steam/logs/autoshutdown.log

# ==============================================
# TIME MESSAGES FOR ZOMBOID --------------------
# ==============================================
 0 12 * * * /home/steam/scripts/includes/message.sh "12:00 PM"
 0 17 * * * /home/steam/scripts/includes/message.sh "05:00 PM"
 0 21 * * * /home/steam/scripts/includes/message.sh "09:00 PM"
30 21 * * 0-4 /home/steam/scripts/includes/message.sh "09:30 PM"
 0 22 * * * /home/steam/scripts/includes/message.sh "10:00 PM"
30 22 * * 0-4 /home/steam/scripts/includes/message.sh "10:30 PM"
45 22 * * 0-4 /home/steam/scripts/includes/message.sh "10:45 PM"
 0 23 * * * /home/steam/scripts/includes/message.sh "11:00 PM"
15 23 * * 0-4 /home/steam/scripts/includes/message.sh "11:15 PM"
30 23 * * * /home/steam/scripts/includes/message.sh "11:30 PM"
45 23 * * 0-4 /home/steam/scripts/include/smessage.sh "11:45 PM"
 0  0 * * * /home/steam/scripts/includes/message.sh "12:00 AM"
15  0 * * * /home/steam/scripts/includes/message.sh "12:15 AM"
30  0 * * * /home/steam/scripts/includes/message.sh "12:30 AM"
45  0 * * * /home/steam/scripts/includes/message.sh "12:45 (Shutdown in 01 hour)"
 0  1 * * * /home/steam/scripts/includes/message.sh "01:00 (Shutdown in 45 minutes)"
15  1 * * * /home/steam/scripts/includes/message.sh "01:15 (Shutdown in 30 minutes)"
30  1 * * * /home/steam/scripts/includes/message.sh "01:30 (Shutdown in 15 minutes)"
35  1 * * * /home/steam/scripts/includes/message.sh "Shutdown in 10 minutes"
40  1 * * * /home/steam/scripts/includes/message.sh "Shutdown in 5 minutes"
41  1 * * * /home/steam/scripts/includes/message.sh "Shutdown in 4 minutes"
42  1 * * * /home/steam/scripts/includes/message.sh "Shutdown in 3 minutes"
43  1 * * * /home/steam/scripts/includes/message.sh "Shutdown in 2 minutes"
44  1 * * * /home/steam/scripts/includes/message.sh "Shutdown in 1 minute"
```