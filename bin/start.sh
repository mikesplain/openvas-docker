#!/bin/bash

/openvas/setup.sh

cd /usr/local/sbin
./openvasmd
./gsad
sleep 30 && /openvas/openvas-check-setup  --v7&
./openvassd -f
