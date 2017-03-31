FROM ubuntu:16.04

COPY config/redis.config /etc/redis/redis.config

ENV DEBIAN_FRONTEND=noninteractive \
    OV_PASSWORD=admin

RUN apt-get update && \
    apt-get install software-properties-common --no-install-recommends -yq && \
    add-apt-repository ppa:mikesplain/openvas -y && \
    add-apt-repository ppa:mrazavi/openvas -y && \
    apt-get clean && \
    apt-get update && \
    apt-get install alien \
                    bzip2 \
                    curl \
                    dirb \
                    dnsutils \
                    libopenvas9-dev \
                    net-tools \
                    nikto \
                    nmap \
                    nsis \
                    openssh-client \
                    openvas9 \
                    rpm \
                    rsync \
                    sendmail \
                    sqlite3 \
                    texlive-latex-base \
                    texlive-latex-extra \
                    texlive-latex-recommended \
                    w3af \
                    wapiti \
                    wget \
                    -yq && \
    apt-get purge \
        texlive-pstricks-doc \
        texlive-pictures-doc \
        texlive-latex-extra-doc \
        texlive-latex-base-doc \
        texlive-latex-recommended-doc \
        software-properties-common \
        -yq && \
    apt-get autoremove -yq && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/Arachni/arachni/releases/download/v1.5/arachni-1.5-0.5.11-linux-x86_64.tar.gz && \
    tar -zxvf arachni-1.5-0.5.11-linux-x86_64.tar.gz && \
    mv arachni-1.5-0.5.11 /opt/arachni && \
    ln -s /opt/arachni/bin/* /usr/local/bin/ && \
    rm -rf arachni*

COPY start /start

RUN mkdir -p /var/run/redis && \
    wget -q --no-check-certificate \
      https://svn.wald.intevation.org/svn/openvas/trunk/tools/openvas-check-setup \
      -O /openvas-check-setup && \
    chmod +x /openvas-check-setup && \
    sed -i 's/DAEMON_ARGS=""/DAEMON_ARGS="-a 0.0.0.0"/' /etc/init.d/openvas-manager && \
    sed -i 's/DAEMON_ARGS=""/DAEMON_ARGS="--mlisten 127.0.0.1 -m 9390"/' /etc/init.d/openvas-gsa && \
    sed -i 's/PORT_NUMBER=4000/PORT_NUMBER=443/' /etc/default/openvas-gsa && \
    greenbone-nvt-sync && \
    greenbone-scapdata-sync && \
    greenbone-certdata-sync && \
    BUILD=true /start && \ 
    service openvas-scanner stop && \
    service openvas-manager stop && \
    service openvas-gsa stop && \
    service redis-server stop

RUN apt-get update && \
    apt-get install -y postfix supervisor libsasl2-modules syslog-ng-core mailutils && \
    apt-get autoremove -yq

COPY sasl_passwd_template /
COPY main.cf_template /

ENV BUILD=""

ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 /usr/local/bin/dumb-init
RUN chmod +x /usr/local/bin/dumb-init

ENTRYPOINT ["dumb-init","--"]
CMD /start

EXPOSE 25
EXPOSE 443
