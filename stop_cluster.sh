#!/bin/bash

# Stops frodo cluster.

sudo -u postgres /usr/lib/postgresql/9.5/bin/pg_ctl -D /frodo stop

echo "Done."
