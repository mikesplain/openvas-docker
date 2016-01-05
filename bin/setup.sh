#!/bin/bash

echo "Starting setup..."

openvas-mkcert -f -q
ldconfig
openvassd
openvas-nvt-sync
openvas-scapdata-sync
openvas-certdata-sync
openvas-mkcert-client -n -i
echo "Starting openvasmd"
openvasmd
echo "Rebuilding Openvasmd..."
n=1
until [ $n -eq 4 ]
do
         timeout 10m openvasmd --rebuild -v;
        if [ $? -eq 0 ]; then
                 break;
         fi
         echo "Rebuild failed, attempt: $n"
         n=$[$n+1]
         echo "Cleaning up"
         ps aux | grep openvassd| awk '{print $2}' |xargs kill -9
         ps aux | grep openvasmd| awk '{print $2}' |xargs kill -9
         openvassd
done
echo "Creating Admin user..."
openvasmd --create-user=${OPENVAS_ADMIN_USER} --role=Admin
echo "Setting Admin user password..."
openvasmd --user=${OPENVAS_ADMIN_USER} --new-password=${OPENVAS_ADMIN_PASSWORD}
echo "Killing some locked up openvassd's"
# At this point, usually openvassd locks up so lets kill it
ps aux | grep openvassd| awk '{print $2}' |xargs kill -9

echo "Finished setup..."
