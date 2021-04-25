#!/bin/bash

/opt/gvm/sbin/openvas --update-vt-info
export PKG_CONFIG_PATH=/opt/gvm/lib:/opt/gvm/lib/pkgconfig:$PKG_CONFIG_PATH

cd /tmp/gvm-source/gvmd
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/opt/gvm
make
make install

cd ../../gsa
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/opt/gvm -DCMAKE_BUILD_TYPE=RELEASE
make
make install

ldconfig