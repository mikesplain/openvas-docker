#!/bin/bash

echo "Starting setup..."

openvas-mkcert -q
ldconfig
openvassd
openvas-nvt-sync
openvas-scapdata-sync
openvas-certdata-sync
openvas-mkcert-client -n -i
openvasmd --rebuild --progress
openvasmd --create-user=admin --role=Admin
openvasmd --user=admin --new-password=openvas

echo "Finished setup..."
