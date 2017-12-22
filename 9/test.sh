#!/bin/bash

docker run -d -p 4000:4000 --name openvas9 openvas9

echo "Waiting for startup to complete..."
until docker logs openvas9 | grep -E 'It seems like your OpenVAS-9 installation is'; do
  echo .
  sleep 5
done

docker logs openvas9 | grep -E 'It seems like your OpenVAS-9 installation is OK'



