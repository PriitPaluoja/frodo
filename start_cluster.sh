#!/bin/bash

# 1. Stops main cluster.
# 2. Starts frodo cluster.

version=$(ls /usr/lib/postgresql)
line_count=$(echo $version | wc -l)
if [ $line_count -ne 1 ]
then
	echo "Found $line_count dirs in /usr/lib/postgresql. Expected 1. Dying slowly..."
	exit 1
fi

# stop main cluster
sudo -u postgres /usr/lib/postgresql/$version/bin/pg_ctl stop -D /etc/postgresql/$version/main 

# start frodo cluster
sudo -u postgres /usr/lib/postgresql/$version/bin/pg_ctl -l /frodo/log.txt -D /frodo start

echo "Done."
