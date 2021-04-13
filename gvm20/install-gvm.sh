#!/bin/bash

export PKG_CONFIG_PATH=/opt/gvm/lib/pkgconfig:$PKG_CONFIG_PATH

# GVM
cd /tmp/gvm-source/gvm-libs
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/opt/gvm
make
make install

cd ../../openvas-smb/
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/opt/gvm
make
make install

cd ../../openvas/
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/opt/gvm
make
make install
