#!/bin/bash

useradd -r -d /opt/gvm -c "GVM (OpenVAS) User" -s /bin/bash gvm
mkdir /opt/gvm
chown gvm:gvm /opt/gvm
apt-get -y install gcc g++ make bison flex libksba-dev curl redis libpcap-dev cmake git pkg-config libglib2.0-dev libgpgme-dev libgnutls28-dev uuid-dev libssh-gcrypt-dev libldap2-dev gnutls-bin libmicrohttpd-dev libhiredis-dev zlib1g-dev libxml2-dev libradcli-dev clang-format libldap2-dev doxygen nmap gcc-mingw-w64 xml-twig-tools libical-dev perl-base heimdal-dev libpopt-dev libsnmp-dev python3-setuptools python3-paramiko python3-lxml python3-defusedxml python3-dev gettext python3-polib xmltoman python3-pip texlive-fonts-recommended xsltproc texlive-latex-extra rsync ufw ntp libunistring-dev git --no-install-recommends
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
apt-get update
apt-get -y install yarn

/usr/bin/yarn install
/usr/bin/yarn upgrade

apt-get install postgresql postgresql-contrib postgresql-server-dev-all -yq

mkdir -p /etc/postgresql/data /var/log/postgresql
chown postgres:postgres /etc/postgresql/data /var/log/postgresql

# postgresql doesn't work yet, we'll come back to it.

mkdir -p /tmp/gvm-source /opt/gvm /var/run/redis
cd /tmp/gvm-source

git clone -b gvm-libs-20.08 https://github.com/greenbone/gvm-libs.git
git clone https://github.com/greenbone/openvas-smb.git
git clone -b openvas-20.08 https://github.com/greenbone/openvas.git
git clone -b ospd-20.08 https://github.com/greenbone/ospd.git
git clone -b ospd-openvas-20.08 https://github.com/greenbone/ospd-openvas.git
git clone -b gvmd-20.08 https://github.com/greenbone/gvmd.git
git clone -b gsa-20.08 https://github.com/greenbone/gsa.git
git clone https://github.com/greenbone/python-gvm.git
git clone https://github.com/greenbone/gvm-tools.git

chown -R gvm:gvm .

sed -i 's|PATH="|PATH="/opt/gvm/bin:/opt/gvm/sbin:/opt/gvm/.local/bin:|g' /etc/environment
