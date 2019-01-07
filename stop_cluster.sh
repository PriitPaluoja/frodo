#!/bin/bash

# Stops frodo cluster.
version=$(ls /usr/lib/postgresql)
sudo -u postgres /usr/lib/postgresql/$version/bin/pg_ctl -D /frodo stop

echo "Done."
