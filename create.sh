#!/bin/bash

world="$1"

# ensure all requisite directories exist
mkdir -p servers
mkdir -p servers/$world
mkdir -p servers/$world/backups
mkdir -p servers/$world/backups/current
mkdir -p servers/$world/backups/daily
mkdir -p servers/$world/backups/weekly
mkdir -p servers/$world/backups/monthly

# setup server.properties

# download minecraft.jar? copy?

# initial execute? java -jar minecraft.jar

# auto eula?

# setup screen?

# setup run.sh?

# make sure permissions are still good
chown -R root:sudo ./
