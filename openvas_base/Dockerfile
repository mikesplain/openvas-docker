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
                    libcurl4-gnutls-dev \
                    xsltproc \
                    libmicrohttpd-dev \
                    wget \
                    rsync \
                    texlive-latex-base \
                    texlive-latex-recommended \
                    texlive-latex-extra \
                    unzip \
                    nmap -y --no-install-recommends && \
    mkdir /openvas-src && \
    cd /openvas-src && \
        wget http://wald.intevation.org/frs/download.php/1907/openvas-libraries-7.0.7.tar.gz && \
        wget http://wald.intevation.org/frs/download.php/1844/openvas-scanner-4.0.5.tar.gz && \
        wget http://wald.intevation.org/frs/download.php/1911/openvas-manager-5.0.8.tar.gz && \
        wget http://wald.intevation.org/frs/download.php/1915/greenbone-security-assistant-5.0.5.tar.gz && \
        wget http://wald.intevation.org/frs/download.php/1803/openvas-cli-1.3.1.tar.gz && \
    cd /openvas-src/ && \
        tar zxvf openvas-libraries-7.0.7.tar.gz && \
        tar zxvf openvas-scanner-4.0.5.tar.gz && \
        tar zxvf openvas-manager-5.0.8.tar.gz && \
        tar zxvf greenbone-security-assistant-5.0.5.tar.gz && \
        tar zxvf openvas-cli-1.3.1.tar.gz && \
    cd /openvas-src/openvas-libraries-7.0.7 && \
        mkdir source && \
        cd source && \
        cmake .. && \
        make && \
        make install && \
    cd /openvas-src/openvas-scanner-4.0.5 && \
        mkdir source && \
        cd source && \
        cmake .. && \
        make && \
        make install && \
    cd /openvas-src/openvas-manager-5.0.8 && \
        mkdir source && \
        cd source && \
        cmake .. && \
        make && \
        make install && \
    cd /openvas-src/greenbone-security-assistant-5.0.5 && \
        mkdir source && \
        cd source && \
        cmake .. && \
        make && \
        make install && \
    cd /openvas-src/openvas-cli-1.3.1 && \
        mkdir source && \
        cd source && \
        cmake .. && \
        make && \
        make install && \
    rm -rf /openvas-src && \
    mkdir /dirb && \
    cd /dirb && \
    wget http://downloads.sourceforge.net/project/dirb/dirb/2.22/dirb222.tar.gz && \
        tar -zxvf dirb222.tar.gz && \
        cd dirb222 && \
        chmod 700 -R * && \
        ./configure && \
        make && \
        make install && \
    cd / && \
    cd /tmp && \
    wget http://downloads.arachni-scanner.com/arachni-1.0.6-0.5.6-linux-x86_64.tar.gz && \
        tar -zxvf arachni-1.0.6-0.5.6-linux-x86_64.tar.gz && \
        mv arachni-1.0.6-0.5.6 /opt/arachni && \
        ln -s /opt/arachni/bin/arachni /usr/local/bin/arachni && \
    apt-get clean -yq && \
    apt-get autoremove -yq && \
    apt-get purge -y --auto-remove build-essential cmake && \
    cd ~ && \
    wget https://github.com/sullo/nikto/archive/master.zip && \
    unzip master.zip -d /tmp && \
    mv /tmp/nikto-master/program /opt/nikto && \
    rm -rf /tmp/nikto-master && \
    echo "EXECDIR=/opt/nikto\nPLUGINDIR=/opt/nikto/plugins\nDBDIR=/opt/nikto/databases\nTEMPLATEDIR=/opt/nikto/templates\nDOCDIR=/opt/nikto/docs" >> /opt/nikto/nikto.conf && \
    ln -s /opt/nikto/nikto.pl /usr/local/bin/nikto.pl && \
    ln -s /opt/nikto/nikto.conf /etc/nikto.conf

RUN mkdir /etc/service/gsad && \
    mkdir /etc/service/openvassd && \
    mkdir /etc/service/openvasmd

ADD bin/gsad /etc/service/gsad/run
ADD bin/openvassd /etc/service/openvassd/run
ADD bin/openvasmd /etc/service/openvasmd/run

RUN wget https://svn.wald.intevation.org/svn/openvas/trunk/tools/openvas-check-setup --no-check-certificate

RUN mkdir -p /etc/my_init.d
ADD bin/rebuild_service.sh /etc/my_init.d/rebuild_service.sh
ADD bin/rebuild.sh /usr/local/bin/rebuid.sh
ADD bin/setup.sh /etc/my_init.d/000_setup.sh

RUN chmod 700 /etc/service/gsad/run /etc/service/openvassd/run /etc/service/openvasmd/run /openvas-check-setup /etc/my_init.d/rebuild_service.sh /usr/local/bin/rebuid.sh /etc/my_init.d/000_setup.sh

# Expose UI
EXPOSE 443

# Scanner ports
EXPOSE 9390
EXPOSE 9391
