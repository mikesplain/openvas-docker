#!/bin/bash

echo "Setup"

if [ -n "$QUAY_PASSWORD" ]; then
    docker login -u="${QUAY_USER}" -p="${QUAY_PASSWORD}" quay.io
fi

cd $(dirname $0)
mkdir -p logs images

docker build -t openvas9 .
docker tag openvas9 quay.io/mikesplain/openvas:travis-${TRAVIS_BUILD_ID}

if [ -n "$QUAY_PASSWORD" ]; then
    docker push quay.io/mikesplain/openvas:travis-${TRAVIS_BUILD_ID}
fi

./test.sh

if [ $? -eq 1 ]; then
    echo "Test failure. Look in log to debug."
    exit 1
fi

echo "Test Complete!"