#!/bin/bash

docker run -d -p 8443:443 --name openvas9 openvas9

echo "Waiting for startup to complete..."
until docker logs openvas9 | grep -E 'It seems like your OpenVAS-9 installation is'; do
  echo .
  sleep 5
done

if $(curl -k https://localhost:8443/login/login.html | grep -q "Greenbone Security Assistant"); then
  echo "Greenbone started successfully!"
else
  echo "Greenbone couldn't be found. There's probably something wrong"
  exit 1
fi
