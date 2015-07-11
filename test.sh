#!/bin/bash

docker run -d -p 443:443 -p 9390:9390 -p 9391:9391 --name openvas mikesplain/openvas

echo "Waiting for startup to complete..."
until docker top openvas | grep gsad; do \
  echo "." ; \
  sleep 2 ; \
done

/openvas/openvas-check-setup
