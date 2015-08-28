#!/bin/bash

echo "Starting Openvas..."

cd /usr/local/sbin
echo "Starting Openvasmd"
./openvasmd
echo "Starting gsad"
./gsad
echo "Starting Openvassd"
./openvassd
echo "Rebuilding openvasmd"
n=1
until [ $n -eq 4 ]
do
         timeout 5m openvasmd --rebuild -v;
        if [ $? -eq 0 ]; then
                 break;
         fi
         echo "Rebuild failed, attempt: $n"
         n=$[$n+1]
done

echo "Checking setup"
/openvas/openvas-check-setup --v7

echo "Done."
echo "Starting infinite loop..."

echo "Press [CTRL+C] to stop.."

while true
do
	sleep 1
done
