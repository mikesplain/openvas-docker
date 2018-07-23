FROM ubuntu:16.04

COPY config/redis.config /etc/redis/redis.config
COPY config/sasl_passwd_template /
COPY config/main.cf_template /
COPY config/ldapUserSync/* /ldapUserSync/
COPY start /start

ENV DEBIAN_FRONTEND=noninteractive \
    OV_PASSWORD=admin \
    PUBLIC_HOSTNAME=openvas

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
                    libsasl2-modules \
                    net-tools \
                    nikto \
                    nmap \
                    nsis \
                    postfix \
                    openssh-client \
                    openvas9 \
                    rpm \
                    rsync \
                    smbclient \
                    socat \
                    sqlite3 \
                    sshpass \
                    texlive-latex-base \
                    texlive-latex-extra \
                    texlive-latex-recommended \
                    w3af \
                    wapiti \
                    wget \
                    ldap-utils \
                    -yq && \
    apt-get upgrade -yq && \
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

RUN wget -q https://github.com/Arachni/arachni/releases/download/v1.5/arachni-1.5-0.5.11-linux-x86_64.tar.gz && \
    tar -zxf arachni-1.5-0.5.11-linux-x86_64.tar.gz && \
    mv arachni-1.5-0.5.11 /opt/arachni && \
    ln -s /opt/arachni/bin/* /usr/local/bin/ && \
    rm -rf arachni*

RUN mkdir -p /var/run/redis && \
    wget -q --no-check-certificate \
    https://wald.intevation.org/svn/openvas/trunk/tools/openvas-check-setup \
      -O /openvas-check-setup && \
    chmod +x /openvas-check-setup && \
    sed -i 's/DAEMON_ARGS=""/DAEMON_ARGS="-a 0.0.0.0"/' /etc/init.d/openvas-manager && \
    sed -i 's/DAEMON_ARGS=""/DAEMON_ARGS="--mlisten 127.0.0.1 -m 9390 --gnutls-priorities=SECURE128:-AES-128-CBC:-CAMELLIA-128-CBC:-VERS-SSL3.0:-VERS-TLS1.0"/' /etc/init.d/openvas-gsa && \
    sed -i '/^\[ -n "$HTTP_STS_MAX_AGE" \]/a[ -n "$PUBLIC_HOSTNAME" ] && DAEMON_ARGS="$DAEMON_ARGS --allow-header-host=$PUBLIC_HOSTNAME"' /etc/init.d/openvas-gsa && \
    sed -i 's/PORT_NUMBER=4000/PORT_NUMBER=443/' /etc/default/openvas-gsa && \
    greenbone-nvt-sync > /dev/null && \
    greenbone-scapdata-sync > /dev/null && \
    greenbone-certdata-sync > /dev/null && \
    BUILD=true /start && \
    service openvas-scanner stop && \
    service openvas-manager stop && \
    service openvas-gsa stop && \
    service redis-server stop


ENV BUILD=""

CMD /start

EXPOSE 443 9390
