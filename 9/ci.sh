#!/bin/bash

cd $(dirname $0)
mkdir -p logs images

docker build -t openvas9 . 2>&1 | tee logs/build.log
docker save openvas9 | gzip -c  > images/openvas9.tar.gz
./test.sh 2>&1 | tee logs/test.log
docker logs openvas9 2>&1 | tee logs/container.log