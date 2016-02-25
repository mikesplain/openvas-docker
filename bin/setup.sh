#!/bin/bash

# Adapted test from http://www.openvas.org/install-packages-v6.html

echo "Starting setup..."
mkdir -p /var/run/redis
redis-server /etc/redis/redis.config
ldconfig

test -e /var/lib/openvas/CA/cacert.pem  || openvas-mkcert -q
openvas-nvt-sync
test -e /var/lib/openvas/users/om || openvas-mkcert-client -n om -i
/etc/init.d/openvas-manager stop
/etc/init.d/openvas-scanner stop
openvassd
openvasmd --rebuild
openvas-scapdata-sync
openvas-certdata-sync


echo "Creating Admin user..."
openvasmd --create-user=admin --role=Admin
echo "Setting Admin user password..."
openvasmd --user=admin --new-password=openvas
echo "Killing some locked up openvassd's"
killall openvassd
sleep 15

echo "Finished setup..."
