#!/bin/bash

# Starts frodo cluster.

sudo -u postgres /usr/lib/postgresql/9.5/bin/pg_ctl -l /frodo/log.txt -D /frodo start

echo "Done."
