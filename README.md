OpenVAS image for Docker
==============

[![Circle CI](https://circleci.com/gh/mikesplain/openvas-docker.svg?style=svg)](https://circleci.com/gh/mikesplain/openvas-docker)

A Docker container for OpenVAS 7 on the Ubuntu 14.04 phusion/baseimage.  By default, the latest images includes the OpenVAS Base as well as the NVTs and Certs required to run OpenVAS.  We also package a version without NVTs and Certs if you want to sync them in realtime.

Requirements
------------
Docker
Ports available: 443, 9390, 9391

Usage
-----

There are now a number of OpenVAS 7 images you can choose from:
- mikesplain/openvas_base => Just executables. Will download certs and NVTs at start.
- mikesplain/openvas => Base + NVTs and Certs.

Note: This was recently changed to force base updates and improve container linking.  We are now utilizing 2 docker hub repos rather than 1.


Simply run:

```
docker run -d -p 443:443 -p 9390:9390 -p 9391:9391 mikesplain/openvas
```

This will grab the container from the docker registry and start it up.  Openvas startup can take some time (2-3 minutes whilte NVT's are scanned and databases rebuilt), so be patient.  That being said, the web UI should be available almost immediately.  Goto `https://<machinename>`

```
Username: admin
Password: openvas
```

To check the status of the process, run:

```
docker top mikesplain/openvas
```

In the output, look for the process scanning cert data.  It contains a percentage.

To run bash inside the container run:

```
docker exec -it <container id> bash
```

Image Notes
-----

This image was recently updated into 2 main versions.  The base build sets up OpenVAS in a condensed format to make it quicker to download.  It also creates necessary scripts for startup to start NVT and Cert syncing.

With that in mind, syncing of data occurs via wget, curl and rsync.  In certain environments, one or many of those connections may not be possible.  For these cases, we also build the "full" version of OpenVAS which includes the needed NVTs and Certs. Docker compressions of images really helps here and compresses nearly 1 GB of images into ~150 MB.

These changes allowed me to reduce the size of the image by almost 2 GB.

Out Of Date NVTs / Certs
------------------------

If at any point you believe NVTs and/or Certs need to be updated, please put in a [pull request](https://github.com/mikesplain/openvas-docker/pulls) with a simple change like this:

```
# Fork Repo and git clone

git checkout -b update_nvts_and_certs
echo `date` > build
git commit -am "Please update NVTs and Certs"
git push

# Open PR
```

Contributing
------------

I'm always happy to accept [pull requests](https://github.com/mikesplain/openvas-docker/pulls) or [issues](https://github.com/mikesplain/openvas-docker/issues).

Thanks
------
Thanks to hackertarget for the great tutorial: http://hackertarget.com/install-openvas-7-ubuntu/
