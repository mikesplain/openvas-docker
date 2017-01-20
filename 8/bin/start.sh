#!/bin/bash

HTTP_ONLY=${HTTP_ONLY:-}
set_http_only=""

if [ "$HTTP_ONLY" = "true" ]; then
  set_http_only="--http-only"
fi

echo "Starting Redis"
mkdir -p /var/run/redis
redis-server /etc/redis/redis.config

cd /usr/local/sbin

echo "Starting gsad"
# http://wiki.openvas.org/index.php/Edit_the_SSL_ciphers_used_by_GSAD
gsad --gnutls-priorities="SECURE256:-VERS-TLS-ALL:+VERS-TLS1.2" $set_http_only

echo "Updating NVTs, CVEs, CPEs..."
openvas-nvt-sync
openvas-scapdata-sync
openvas-certdata-sync

echo "Starting Openvas..."
service openvas-manager restart
service openvas-scanner restart

echo "Starting rebuild process..."
echo "This may take a minute or two..."
openvasmd --rebuild

# Check whether an admin user already exists
if ! openvasmd --get-users | grep -q admin; then

    # Add the user
    echo "Adding new admin user..."
    openvasmd --create-user=admin --role=Admin
    echo "Setting Admin user password..."
    openvasmd --user=admin --new-password=openvas

	# Since this is a first time run we need to rebuild again to fix OIDs displaying instead of titles
	openvasmd --rebuild

fi

echo "Checking setup"
/openvas/openvas-check-setup --v8 --server
echo "Done."

echo "Starting infinite loop..."

echo "Press [CTRL+C] to stop.."

while true
do
	sleep 1
done
