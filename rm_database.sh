#!/bin/bash

# Parameters
# 1. Database name
# 2. Database role name
# NOTE: All passed parameters must be sanitized.

# Assumes a cluster is running on 5432.
# 1. Removes database with given name.
# 2. Removes role with given role name.

db_name=$1
db_user=$2

sudo -u postgres psql -t -c "DROP DATABASE $db_name;"
sudo -u postgres psql -t -c "DROP ROLE $db_user;"

echo "Done."
