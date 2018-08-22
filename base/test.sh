#!/bin/bash

docker-compose -f ../docker-compose.yml up -d

echo "Waiting for startup to complete..."
until docker logs openvas-docker_openvas_1 | grep -E 'It seems like your OpenVAS-9 installation is'; do
  echo .
  sleep 5
done

if $(curl -k https://localhost/login/login.html | grep -q "Greenbone Security Assistant"); then
  echo "Greenbone started successfully!"
else
  echo "Greenbone couldn't be found. There's probably something wrong"
  exit 1
fi
