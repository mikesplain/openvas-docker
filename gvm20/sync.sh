#!/bin/bash

chown -R gvm:gvm /opt/gvm

sudo su - gvm sh -c "/opt/gvm/bin/greenbone-nvt-sync"
sudo su - gvm sh -c "/opt/gvm/bin/greenbone-certdata-sync"
sudo su - gvm sh -c "/opt/gvm/bin/greenbone-scapdata-sync"
sudo su - gvm sh -c "/opt/gvm/sbin/greenbone-feed-sync --type GVMD_DATA"
sudo su - gvm sh -c "/opt/gvm/sbin/greenbone-feed-sync --type SCAP"
sudo su - gvm sh -c "/opt/gvm/sbin/greenbone-feed-sync --type CERT"
