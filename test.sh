#!/bin/bash

docker run -d -p 443:443 -p 9390:9390 -p 9391:9391 --name openvas openvas

echo "Waiting for startup to complete..."
until docker logs openvas | grep -E 'It seems like your OpenVAS-7 installation is'; do
  echo "." ;
  sleep 2 ;
done

docker logs openvas | grep -E 'It seems like your OpenVAS-7 installation is OK'
