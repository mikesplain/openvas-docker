#!/bin/bash


cd /usr/local/sbin
./openvasmd
./gsad
./openvassd
openvasmd --rebuild --progress -v
/openvas/openvas-check-setup --v7

while true
do
	echo "Press [CTRL+C] to stop.."
	sleep 1
done
