#!/bin/bash

cd $(dirname $0)
mkdir logs images

docker build -t openvas9 .
docker save openvas9 | gzip -c  > images/openvas9.tar.gz
./test.sh
