# Zomboid Server Scripts
The following collection of scripts are used to monitor, manage and update the Project Zomboid Server for the private Space Brothers group.

Some terminology used below is as follows:
- **Server**: The physical machine running all of these processes
- **Zomboid Server**: The Project Zomboid server executeable that powers the game

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
| `cron_monitor.sh` | Runs every minute to ensure that Zomboid is running and restart it if it is not |
| `cron_shutdown.sh` | Shuts the zomboid server down at the end of the night, runs backups and powers off |
| `cron_startup.sh` | Triggers on physical server boot to start the Zomboid application |
| `cron_update.sh` | Updates Zomboid through steam, all of it's mods through workshop and then starts server |


## Includes used in the above tasks
These *partials* are used within all the above scripts. Rather than type out the same commands over and over they have been written once to a file and then included in the above scripts.

For example, the `server-restart.sh` script actually includes the stop, update and start includes.

| Script | Purpose |
| ------------ | ------------ |
| `/includes/message.sh` | Sends an in-game message to all connected zomboid players |
| `/includes/start.sh` | Starts the Zomboid Server |
| `/includes/stop.sh` | Stops the Zomboid Server |
| `/includes/update.sh` | Updates the Zomboid Server software |
