#!/bin/bash

docker run -d -p 4000:4000 -p 9390:9390 -p 9391:9391 --name openvas9 openvas9

echo "Waiting for startup to complete..."
until docker logs --tail=15 openvas9 | grep -E 'It seems like your OpenVAS-9 installation is'; do
  echo "." ;
  echo "=========================================================================";
  docker logs --tail=15 openvas9
  echo "=========================================================================";
  sleep 5 ;
done

docker logs --tail=15 openvas9 | grep -E 'It seems like your OpenVAS-9 installation is OK'
