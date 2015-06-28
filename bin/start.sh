#!/bin/bash

/openvas/setup.sh

cd /usr/local/sbin
./openvasmd
./gsad
./openvassd -f
