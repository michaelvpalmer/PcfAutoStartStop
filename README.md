### About
A cron script to automate Pivotal Cloud Foundry startup and shutdowns for experimental environments.

### Run
1. Fill In the Director information in the script
2. Choose which PCF components you wish to be included in the startup or shutdown and set to true or false
3. Run the script from command line `./pcfStartStop.sh <start or stop>` or a cron job (see example crontabFile)
