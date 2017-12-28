#!/bin/bash

cd $(dirname $0)
mkdir -p logs images

docker build -t openvas9 . 
docker tag openvas9 quay.io/mikesplain/openvas:travis-${TRAVIS_BUILD_ID}
docker push quay.io/mikesplain/openvas:travis-${TRAVIS_BUILD_ID}
./test.sh 

echo "Test Complete!"