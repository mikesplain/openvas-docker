# OpenVAS
# Based on: http://hackertarget.com/install-openvas-7-ubuntu/
#
# VERSION       1.0.0

FROM phusion/baseimage
MAINTAINER Mike Splain mike.splain@gmail.com

RUN apt-get update -y
RUN apt-get install build-essential \
                    bison \
                    flex \
                    cmake \
                    pkg-config \
                    libglib2.0-dev \
                    libgnutls-dev \
                    libpcap0.8-dev \
                    libgpgme11 \
                    libgpgme11-dev \
                    doxygen \
                    libuuid1 \
                    uuid-dev \
                    sqlfairy \
                    xmltoman \
                    sqlite3 \
                    libsqlite3-dev \
                    libsqlite3-tcl \
                    libxml2-dev \
                    libxslt1.1 \
                    libxslt1-dev \
                    xsltproc \
                    libmicrohttpd-dev \
                    wget \
                    rsync \
                    texlive-latex-base \
                    texlive-latex-recommended \
                    texlive-latex-extra \
                    nmap -y --no-install-recommends

RUN mkdir openvas-src && \
    cd openvas-src/ && \
    wget http://wald.intevation.org/frs/download.php/1833/openvas-libraries-7.0.6.tar.gz && \
    wget http://wald.intevation.org/frs/download.php/1844/openvas-scanner-4.0.5.tar.gz && \
    wget http://wald.intevation.org/frs/download.php/1849/openvas-manager-5.0.7.tar.gz && \
    wget http://wald.intevation.org/frs/download.php/1799/greenbone-security-assistant-5.0.4.tar.gz && \
    wget http://wald.intevation.org/frs/download.php/1803/openvas-cli-1.3.1.tar.gz

RUN cd openvas-src/ && \
    tar zxvf openvas-libraries-7.0.6.tar.gz && \
    tar zxvf openvas-scanner-4.0.5.tar.gz && \
    tar zxvf openvas-manager-5.0.7.tar.gz && \
    tar zxvf greenbone-security-assistant-5.0.4.tar.gz && \
    tar zxvf openvas-cli-1.3.1.tar.gz

RUN cd openvas-src/openvas-libraries-7.0.6 && \
    mkdir source && \
    cd source && \
    cmake .. && \
    make && \
    make install

RUN cd openvas-src/openvas-scanner-4.0.5 && \
    mkdir source && \
    cd source && \
    cmake .. && \
    make && \
    make install

RUN cd openvas-src/openvas-manager-5.0.7 && \
    mkdir source && \
    cd source && \
    cmake .. && \
    make && \
    make install

RUN cd openvas-src/greenbone-security-assistant-5.0.4 && \
    mkdir source && \
    cd source && \
    cmake .. && \
    make && \
    make install

RUN cd openvas-src/openvas-cli-1.3.1 && \
    mkdir source && \
    cd source && \
    cmake .. && \
    make && \
    make install

RUN openvas-mkcert -q && \
    ldconfig && \
    openvassd && \
    openvas-nvt-sync && \
    openvas-scapdata-sync && \
    openvas-certdata-sync && \
    openvas-mkcert-client -n -i && \
    openvasmd --rebuild --progress && \
    openvasmd --create-user=admin --role=Admin && \
    openvasmd --user=admin --new-password=openvas

# Expose UI
EXPOSE 443

# Scanner ports
EXPOSE 9390
EXPOSE 9391

RUN mkdir /etc/service/gsad && \
    mkdir /etc/service/openvassd && \
    mkdir /etc/service/openvasmd

ADD bin/gsad /etc/service/gsad/run
ADD bin/openvassd /etc/service/openvassd/run
ADD bin/openvasmd /etc/service/openvasmd/run

RUN wget https://svn.wald.intevation.org/svn/openvas/trunk/tools/openvas-check-setup --no-check-certificate

RUN mkdir -p /etc/my_init.d
ADD bin/rebuild.sh /etc/my_init.d/rebuild.sh

RUN chmod 700 /etc/service/gsad/run /etc/service/openvassd/run /etc/service/openvasmd/run /openvas-check-setup /etc/my_init.d/rebuild.sh
