#!/bin/bash

echo "Starting setup..."

openvas-mkcert -f -q
ldconfig
openvassd
openvas-nvt-sync
openvas-scapdata-sync
openvas-certdata-sync
openvas-mkcert-client -n -i
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
done
echo "Creating Admin user..."
openvasmd --create-user=admin --role=Admin
echo "Setting Admin user password..."
openvasmd --user=admin --new-password=openvas
echo "Killing some locked up openvassd's"
# At this point, usually openvassd locks up so lets kill it
ps aux | grep openvassd| awk '{print $2}' |xargs kill -9

echo "Finished setup..."
