#!/usr/bin/env bash

#echo "Starting redis and openvas"
#/usr/sbin/service redis-server start
#/usr/sbin/service openvas-gsa start
#/usr/sbin/service openvas-manager start
#/usr/sbin/service openvas-scanner start
/usr/sbin/service postfix restart
#/usr/sbin/service mailutils start

set -o nounset
set -o errexit
set -o pipefail

sed -i "s/MANDRILL_USERNAME/${MANDRILL_USERNAME}/g" /etc/postfix/sasl_passwd
sed -i "s/MANDRILL_KEY/${MANDRILL_KEY}/g" /etc/postfix/sasl_passwd

/usr/sbin/postmap /etc/postfix/sasl_passwd

/usr/bin/supervisord


