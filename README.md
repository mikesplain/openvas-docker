OpenVAS image for Docker
==============

[![Circle CI](https://img.shields.io/circleci/project/mikesplain/openvas-docker/master.svg)](https://circleci.com/gh/mikesplain/openvas-docker/tree/master) [![Docker Pulls](https://img.shields.io/docker/pulls/mikesplain/openvas.svg)](https://hub.docker.com/r/mikesplain/openvas/) [![Docker Stars](https://img.shields.io/docker/stars/mikesplain/openvas.svg)](https://hub.docker.com/r/mikesplain/openvas/) [![](https://images.microbadger.com/badges/image/mikesplain/openvas.svg)](https://microbadger.com/images/mikesplain/openvas "Get your own image badge on microbadger.com")

A Docker container for OpenVAS on Ubuntu.  By default, the latest images includes the OpenVAS Base as well as the NVTs and Certs required to run OpenVAS.  We made the decision to move to 9 as the default branch since 8 seems to have [many issues](https://github.com/mikesplain/openvas-docker/issues/84) in docker.  We suggest you use 9 as it is much more stable. Our Openvas9 build was designed to be a smaller image with fewer extras built in. Please note, OpenVAS 8 is no longer being built as OpenVAS 9 is now standard.  The image is can still be pulled from the Docker hub, however the source has been removed in this github as is standard with deprecated Docker Images.

We currently package 2 versions:

| Openvas Version | Tag     | Web UI Port |
|-----------------|---------|-------------|
| 9               | latest/9| 443        |



Usage
-----

Simply run:

```
# latest (9)
docker run -d -p 443:443 --name openvas mikesplain/openvas
# 9
docker run -d -p 443:443 --name openvas mikesplain/openvas:9
```

This will grab the container from the docker registry and start it up.  Openvas startup can take some time (4-5 minutes while NVT's are scanned and databases rebuilt), so be patient.  Once you see a `It seems like your OpenVAS-9 installation is OK.` process in the logs, the web ui is good to go.  Goto `https://<machinename>`

```
Username: admin
Password: admin
```

To check the status of the process, run:

```
docker top openvas
```

In the output, look for the process scanning cert data.  It contains a percentage.

To run bash inside the container run:

```
docker exec -it openvas bash
```

#### OpenVAS Manager
To use OpenVAS Manager, add port `9390` to you docker run command:
```
docker run -d -p 443:443 -p 9390:9390 --name openvas mikesplain/openvas
```

#### Volume Support
We now support volumes. Simply mount your data directory to `/var/lib/openvas/mgr/`:
```
mkdir data
docker run -d -p 443:443 -v $(pwd)/data:/var/lib/openvas/mgr/ --name openvas mikesplain/openvas
```
Note, your local directory must exist prior to running.

#### Set Admin Password
The admin password can be changed by specifying a password at runtime using the env variable `OV_PASSWORD`:
```
docker run -d -p 443:443 -e OV_PASSWORD=securepassword41 --name openvas mikesplain/openvas
```
#### Update NVTs
Occasionally you'll need to update NVTs. We update the container about once a week but you can updater you container by execing into the container and running a few commands:
```
docker exec -it openvas bash
## inside container
greenbone-nvt-sync
openvasmd --rebuild --progress
```


Contributing
------------

I'm always happy to accept [pull requests](https://github.com/mikesplain/openvas-docker/pulls) or [issues](https://github.com/mikesplain/openvas-docker/issues).

Thanks
------
Thanks to hackertarget for the great tutorial: http://hackertarget.com/install-openvas-7-ubuntu/
Thanks to Serge Katzmann for contributing with some great work on OpenVAS 8: https://github.com/sergekatzmann/openvas8-complete
