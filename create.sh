#!/bin/bash

world="$1"

# ensure all requisite directories exist
mdir -p servers
mdir -p servers/$world
mdir -p servers/$world/backups
mdir -p servers/$world/backups/current
mdir -p servers/$world/backups/daily
mdir -p servers/$world/backups/weekly
mdir -p servers/$world/backups/monthly

# setup server.properties

# download minecraft.jar? copy?

# initial execute? java -jar minecraft.jar

# auto eula?

# setup screen?

# setup run.sh?

# make sure permissions are still good
chown -R root:sudo ./
