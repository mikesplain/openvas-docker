#!/bin/bash

cd $(dirname $0)
mkdir logs images

docker build -t openvas . 2>&1 | tee logs/build.log:
docker save openvas | gzip -c  > images/openvas.tar.gz
./test.sh 2>&1 | tee logs/test.log:
docker logs openvas 2>&1 | tee logs/container.log
