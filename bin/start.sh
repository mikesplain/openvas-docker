#!/bin/bash

echo "Starting Openvas..."

cd /usr/local/sbin
echo "Starting Openvasmd"
./openvasmd
echo "Starting gsad"
# http://wiki.openvas.org/index.php/Edit_the_SSL_ciphers_used_by_GSAD
./gsad --gnutls-priorities="SECURE128:-AES-128-CBC:-CAMELLIA-128-CBC:-VERS-SSL3.0:-VERS-TLS1.0"
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
