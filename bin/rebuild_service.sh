#!/bin/sh

exec /usr/local/bin/rebuid.sh >> /var/log/rebuild_service.log 2>&1 &
