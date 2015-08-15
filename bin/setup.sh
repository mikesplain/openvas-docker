#!/bin/bash

echo "Starting setup..."

echo "## Debug: "
openvas-mkcert -q

echo "## Debug: ldconfig"
ldconfig
echo "## Debug: openvassd"
openvassd
echo "## Debug: openvas-nvt-sync"
openvas-nvt-sync
echo "## Debug: openvas-scapdata-sync"
openvas-scapdata-sync
echo "## Debug: openvas-certdata-sync"
openvas-certdata-sync
echo "## Debug: openvas-mkcert-client -n -i"
openvas-mkcert-client -n -i
echo "## Debug: openvasmd --rebuild"
openvasmd --rebuild
echo "## Debug: openvasmd --create-user=admin --role=Admin"
openvasmd --create-user=admin --role=Admin
echo "## Debug: openvasmd --user=admin --new-password=openvas"
openvasmd --user=admin --new-password=openvas
echo "## Debug: ps aux | grep openvassd| awk '{print $2}' |xargs kill -9"
# At this point, usually openvassd locks up so lets kill it
ps aux | grep openvassd| awk '{print $2}' |xargs kill -9

echo "Finished setup..."
