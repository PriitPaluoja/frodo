#!/bin/bash

# Parameters
# 1. Database name
# 2. Database role name
# 3. Database role password
# NOTE: All passed parameters must be sanitized.

# Assumes a cluster is running on 5432.
# 1. Creates a new database.
# 2. Creates a new role.
# 3. Grants all rights on the created database to the created role.

new_db_name=$1
new_db_user=$2
new_db_pass=$3


db_names_str=$(sudo -u postgres psql -t -c "SELECT datname FROM pg_database;")
db_names=( $db_names_str )  
for existing_db in "${db_names[@]}"
do
	if [ $new_db_name = $existing_db ]
	then
		echo "Database $new_db_name already exists! Sauron has won..."
		exit 1
	fi 
done

users_str=$(sudo -u postgres psql -t -c "SELECT usename FROM pg_user;")
users=( $users_str )
for existing_user in "${users[@]}"
do
        if [ $new_db_user = $existing_user ]
        then
                echo "User $new_db_user already exists! Sauron has won..."
                exit 1
        fi
done


sudo -u postgres createuser $new_db_user
sudo -u postgres createdb $new_db_name
sudo -u postgres psql -c "ALTER USER $new_db_user WITH ENCRYPTED PASSWORD '$new_db_pass';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $new_db_name TO $new_db_user;"

echo 'Done.'

