#!/bin/bash

echo "Starting setup..."
mkdir -p /var/run/redis
redis-server /etc/redis/redis.config
ldconfig

echo "Creating certificates..."
openvas-mkcert -q
openvas-mkcert-client -n om -i

echo "Updating NVTs, CVEs, CPEs..."
openvas-nvt-sync
openvas-scapdata-sync
openvas-certdata-sync

echo "Finished setup..."
