FROM ubuntu:16.04

ADD config/redis.config /etc/redis/redis.config
ADD start /start

ENV DEBIAN_FRONTEND=noninteractive \
    OV_PASSWORD=admin

# Select closest mirrors to make apt-get faster
RUN echo "deb mirror://mirrors.ubuntu.com/mirrors.txt xenial main restricted universe multiverse" > /etc/apt/sources.list && \
    echo "deb mirror://mirrors.ubuntu.com/mirrors.txt xenial-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb mirror://mirrors.ubuntu.com/mirrors.txt xenial-security main restricted universe multiverse" >> /etc/apt/sources.list

RUN apt-get update && \
    apt-get install software-properties-common --no-install-recommends -yq && \
    add-apt-repository ppa:mikesplain/openvas -y && \
    add-apt-repository ppa:mrazavi/openvas -y && \
    apt-get clean && \
    apt-get update && \
    apt-get install openvas9 \
                    libopenvas9-dev \
                    sqlite3 \
                    wget \
                    curl \
                    bzip2 \
                    nmap \
                    sqlite3 \
                    nsis \
                    rpm \
                    alien \
                    dnsutils \
                    net-tools \
                    rsync \
                    openssh-client \
                    texlive-latex-base \
                    texlive-latex-extra \
                    texlive-latex-recommended \
                    sendmail \
                    dirb \
                    nikto \
                    w3af \
                    wapiti \
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

RUN mkdir -p /var/run/redis && \
    wget -q --no-check-certificate \
      https://svn.wald.intevation.org/svn/openvas/trunk/tools/openvas-check-setup \
      -O /openvas-check-setup && \
    chmod +x /openvas-check-setup && \
    greenbone-nvt-sync && \
    greenbone-scapdata-sync && \
    greenbone-certdata-sync && \
    BUILD=true /start && \
    service openvas-scanner stop && \
    service openvas-manager stop && \
    service openvas-gsa stop && \
    service redis-server stop

CMD /start
EXPOSE 4000
