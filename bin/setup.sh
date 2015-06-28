#!/bin/bash

echo "Starting setup..."

openvas-mkcert -q
ldconfig
openvassd
openvas-nvt-sync
openvas-scapdata-sync
openvas-certdata-sync
openvas-mkcert-client -n -i
openvasmd --rebuild
openvasmd --create-user=admin --role=Admin
openvasmd --user=admin --new-password=openvas

# At this point, usually openvassd locks up so lets kill it
ps aux | grep openvassd| awk '{print $2}' |xargs kill -9

echo "Finished setup..."
