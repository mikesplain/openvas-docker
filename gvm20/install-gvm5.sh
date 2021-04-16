#!/bin/bash

PY3VER=`python3 --version | grep -o [0-9]\.[0-9]`
mkdir -p /opt/gvm/lib/python$PY3VER/site-packages/
export PYTHONPATH=/opt/gvm/lib/python$PY3VER/site-packages

cd /tmp/gvm-source/ospd
python3 setup.py install --prefix=/opt/gvm
cd ../ospd-openvas
python3 setup.py install --prefix=/opt/gvm