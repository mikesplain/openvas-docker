# OpenVAS
# Based on: http://hackertarget.com/install-openvas-7-ubuntu/

FROM ubuntu
MAINTAINER Mike Splain mike.splain@gmail.com

RUN apt-get update -y && \
    apt-get install build-essential \
                    bison \
                    flex \
                    cmake \
                    rpm \
                    alien \
                    nsis \
                    pkg-config \
                    libglib2.0-dev \
                    libgnutls-dev \
                    libpcap0.8-dev \
                    libgpgme11 \
                    libgpgme11-dev \
                    openssh-client \
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
                    libkrb5-dev \
                    xsltproc \
                    libmicrohttpd-dev \
                    wget \
                    rsync \
                    texlive-latex-base \
                    texlive-latex-recommended \
                    texlive-latex-extra \
                    unzip \
                    wapiti \
                    nmap \
                    -y --no-install-recommends && \
    mkdir /openvas-src && \
    cd /openvas-src && \
        wget http://wald.intevation.org/frs/download.php/2031/openvas-libraries-7.0.10.tar.gz && \
        wget http://wald.intevation.org/frs/download.php/2101/openvas-scanner-4.0.7.tar.gz && \
        wget http://wald.intevation.org/frs/download.php/2105/openvas-manager-5.0.11.tar.gz && \
        wget http://wald.intevation.org/frs/download.php/2109/greenbone-security-assistant-5.0.8.tar.gz && \
        wget http://wald.intevation.org/frs/download.php/1803/openvas-cli-1.3.1.tar.gz && \
    cd /openvas-src/ && \
        tar zxvf openvas-libraries-7.0.10.tar.gz && \
        tar zxvf openvas-scanner-4.0.7.tar.gz && \
        tar zxvf openvas-manager-5.0.11.tar.gz && \
        tar zxvf greenbone-security-assistant-5.0.8.tar.gz && \
        tar zxvf openvas-cli-1.3.1.tar.gz && \
    cd /openvas-src/openvas-libraries-7.0.10 && \
        mkdir source && \
        cd source && \
        cmake .. && \
        make && \
        make install && \
    cd /openvas-src/openvas-scanner-4.0.7 && \
        mkdir source && \
        cd source && \
        cmake .. && \
        make && \
        make install && \
    cd /openvas-src/openvas-manager-5.0.11 && \
        mkdir source && \
        cd source && \
        cmake .. && \
        make && \
        make install && \
    cd /openvas-src/greenbone-security-assistant-5.0.8 && \
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
    wget https://github.com/Arachni/arachni/releases/download/v1.2.1/arachni-1.2.1-0.5.7.1-linux-x86_64.tar.gz && \
        tar -zxvf arachni-1.2.1-0.5.7.1-linux-x86_64.tar.gz && \
        mv arachni-1.2.1-0.5.7.1 /opt/arachni && \
        ln -s /opt/arachni/bin/* /usr/local/bin/ && \
    cd ~ && \
    wget https://github.com/sullo/nikto/archive/master.zip && \
    unzip master.zip -d /tmp && \
    mv /tmp/nikto-master/program /opt/nikto && \
    rm -rf /tmp/nikto-master && \
    echo "EXECDIR=/opt/nikto\nPLUGINDIR=/opt/nikto/plugins\nDBDIR=/opt/nikto/databases\nTEMPLATEDIR=/opt/nikto/templates\nDOCDIR=/opt/nikto/docs" >> /opt/nikto/nikto.conf && \
    ln -s /opt/nikto/nikto.pl /usr/local/bin/nikto.pl && \
    ln -s /opt/nikto/nikto.conf /etc/nikto.conf && \
    mkdir -p /openvas && \
    wget https://svn.wald.intevation.org/svn/openvas/trunk/tools/openvas-check-setup --no-check-certificate -O /openvas/openvas-check-setup && \
    chmod a+x /openvas/openvas-check-setup && \
    apt-get clean -yq && \
    apt-get autoremove -yq && \
    apt-get purge -y --auto-remove build-essential cmake

ADD bin/* /openvas/
RUN chmod 700 /openvas/*.sh && \
    bash /openvas/setup.sh

CMD bash /openvas/start.sh

# Expose UI
EXPOSE 443 9390 9391 9392
