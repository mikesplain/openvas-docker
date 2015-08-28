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
openvasmd --rebuild -v
echo "Checking setup"
/openvas/openvas-check-setup --v7

echo "Done."
echo "Starting infinite loop..."

echo "Press [CTRL+C] to stop.."

while true
do
	sleep 1
done
