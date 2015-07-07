#!/bin/bash

echo "Starting Redis"
/usr/local/bin/redis-server /etc/redis/redis.config

echo "Starting Openvas..."

cd /usr/local/sbin

echo "Starting gsad"
./gsad
echo "Starting Openvassd"
./openvassd
echo "Rebuilding openvasmd"
n=1
until [ $n -eq 4 ]
do
         timeout 10m openvasmd --rebuild -v;
        if [ $? -eq 0 ]; then
                 break;
         fi
         echo "Rebuild failed, attempt: $n"
         n=$[$n+1]
         echo "Cleaning up:"
         rm -rf /usr/local/var/lib/openvas/mgr/tasks.db
done

echo "Starting Openvasmd"
./openvasmd

echo "Checking setup"

until [ $n -eq 50 ]
do
         timeout 10s /openvas/openvas-check-setup --v8 --server;
        if [ $? -eq 0 ]; then
                 break;
         fi
         echo "Re-running openvas-check-setup, attempt: $n"
         n=$[$n+1]
done

echo "Done."

echo "Starting infinite loop..."

echo "Press [CTRL+C] to stop.."

while true
do
	sleep 1
done
