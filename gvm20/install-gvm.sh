#!/bin/bash

# TODO: Figure out which of these is correct
export PKG_CONFIG_PATH=/opt/gvm/lib:/opt/gvm/lib/pkgconfig:$PKG_CONFIG_PATH


# GVM
cd /tmp/gvm-source/gvm-libs
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/opt/gvm ..
make
make install

cd ../../openvas-smb/
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/opt/gvm ..
make
make install

cd ../../openvas/
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/opt/gvm ..
make
make install

# Sync
# TODO: Uncomment
/opt/gvm/bin/greenbone-nvt-sync


/opt/gvm/sbin/openvas --update-vt-info

cd /tmp/gvm-source/gvmd
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/opt/gvm ..
make
make install

cd ../../gsa
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/opt/gvm -DCMAKE_BUILD_TYPE=RELEASE ..
make
make install

ldconfig

/opt/gvm/bin/gvm-manage-certs -a

# Feed Sync
# TODO: Uncomment
/opt/gvm/sbin/greenbone-feed-sync --type SCAP

# ospd
PY3VER=`python3 --version | grep -o [0-9]\.[0-9]`
mkdir -p /opt/gvm/lib/python$PY3VER/site-packages/
export PYTHONPATH=/opt/gvm/lib/python$PY3VER/site-packages

cd /tmp/gvm-source/ospd
python3 setup.py install --prefix=/opt/gvm
pip3 install --system .
cd ../ospd-openvas
python3 setup.py install --prefix=/opt/gvm
pip3 install --system .

mkdir -p /opt/gvm/var/run/
