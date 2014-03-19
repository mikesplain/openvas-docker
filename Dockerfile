# OpenVAS
# Based on: http://www.openvas.org/install-packages-v5.html#openvas_centos_atomic
#
# VERSION       0.1.0

FROM centos
MAINTAINER Mike Splain mike.splain@gmail.com

RUN wget -q -O - http://www.atomicorp.com/installers/atomic |sh

RUN yum update -y
RUN yum install openvas -y -v

# Instead of running the below command, lets break it out so we can set the username and password
#RUN openvas-setup

RUN /usr/sbin/openvas-nvt-sync
RUN /usr/sbin/openvas-certdata-sync
RUN /usr/sbin/openvas-scapdata-sync

RUN /usr/sbin/openvas-mkcert-client -n om -i >/dev/null 2>&1 || :
RUN /usr/sbin/openvasmd -f --rebuild >/dev/null 2>&1 || :

RUN /sbin/service openvas-manager restart  >/dev/null 2>&1
RUN /usr/bin/perl -p -i -e "s[^GSA_ADDRESS=.*][GSA_ADDRESS=0.0.0.0]g" /etc/sysconfig/gsad
RUN /sbin/service gsad restart

# Setup Username and password
RUN /usr/sbin/openvasad -c add_user -n $USERNAME -r Admin --password=Password
RUN /usr/sbin/openvas-adduser

EXPOSE 9392

CMD ["/sbin/service openvas-administrator start"]
