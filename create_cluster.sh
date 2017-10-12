#!/bin/bash

# 1. Installs PostgreSQL (distro standard version)
# 2. Stops default cluster
# 3. Creates cluster Frodo (/frodo)
# 4. Alters conf to allow access from everywhere
# 5. Enables SSL
# NOTE: the script does not start the server


function cleanup(){
	echo "Cleaning up."
	sudo -u postgres /usr/lib/postgresql/$version/bin/pg_ctl start -D /etc/postgresql/$version/main -l /var/log/postgresql/postgresql-$(echo $version)-main.log
	sudo rm -rf /jail
}

sudo apt-get update
sudo apt-get install postgresql

version=$(ls /usr/lib/postgresql)
line_count=$(echo $version | wc -l)
if [ $line_count -ne 1 ]
then
	echo "Found $line_count dirs in /usr/lib/postgresql. Expected 1. Dying slowly..."
	exit 1
fi

sudo -u postgres /usr/lib/postgresql/$version/bin/pg_ctl stop -D /etc/postgresql/$version/main

if [ -d "/frodo" ]
then
	echo "/frodo already exists! Dying slowly..."
	sudo -u postgres /usr/lib/postgresql/$version/bin/pg_ctl start -D /etc/postgresql/$version/main -l /var/log/postgresql/postgresql-$(echo $version)-main.log
	exit 1
fi

sudo mkdir /frodo
sudo chown postgres:postgres /frodo
sudo -u postgres /usr/lib/postgresql/$version/bin/initdb -D /frodo

if [ ! -e "pg_hba.conf" ]
then
	echo "pg_hba.conf not found. Dying slowly..."
	cleanup
	exit 1
fi

if [ ! -e "postgresql.conf" ]
then
        echo "postgresql.conf not found. Dying slowly..."
	cleanup
	exit 1
fi

sudo chown postgres:postgres pg_hba.conf
sudo chown postgres:postgres postgresql.conf
sudo -u postgres cp -f pg_hba.conf /frodo
sudo -u postgres cp -f postgresql.conf /frodo

echo "Setting up SSL..."
sudo apt-get install -y openssl
sudo openssl req -newkey rsa:2048 -nodes -keyout /frodo/server.key -x509 -days 730 -out /frodo/server.crt -subj "/"
sudo chown postgres:postgres /frodo/server.key
sudo chown postgres:postgres /frodo/server.crt
sudo chmod 0600 /frodo/server.key

echo "Done."



