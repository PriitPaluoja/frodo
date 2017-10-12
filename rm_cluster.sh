#!/bin/bash

# 1. Stops frodo cluster.
# 2. Removes /frodo.

sudo -u postgres /usr/lib/postgresql/9.5/bin/pg_ctl -D /frodo stop
sudo rm -rf /frodo

echo "Done."
