openvas-docker
==============

A Docker container for Openvas 7 on the Ubuntu 14.04 phusion/baseimage.  This script is based on [this](http://hackertarget.com/install-openvas-7-ubuntu/) tutorial on building Openvas.

Requirements
------------
Docker
Ports available: 443, 9390, 9391

Usage
-----

Simply run:
```
docker run -d -p 443:443 -p 9390:9390 -p 9391:9391 mikesplain/openvas
```

This will grab the container from the docker registry and start it up.  Openvas can take some time, so be patient.  That being said, the web UI should be available almost immediately.  Goto https://<machinename>
```
Username: admin
Password: openvas
```

To check the status of the process, run:
```
docker top mikesplain/openvas
```

In the output, look for the process scanning cert data.  It contains a percentage.

Notes
-----

This image basically stores all scap, cert, and mk cert data, which means it is not as up to date as the full version.  This makes it faster to setup but currently will need to rebuilt frequently to keep it up to date. In the future, a process will be added to allow updates.

Thanks
------
Thanks to hackertarget for the great tutorial: http://hackertarget.com/install-openvas-7-ubuntu/

Todo
----

Cleanup all the installed packages and src files.
Script to resync certs
