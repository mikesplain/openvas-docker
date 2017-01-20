FROM ubuntu:16.04

ADD config/redis.config /etc/redis/redis.config
ADD start /start

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install software-properties-common -yq && \
    add-apt-repository ppa:mrazavi/openvas -y && \
    apt-get update

RUN apt-get install openvas9 \
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
                    -yq && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/redis && \
    wget -q --no-check-certificate \
      https://svn.wald.intevation.org/svn/openvas/trunk/tools/openvas-check-setup \
      -O /openvas-check-setup && \
    chmod +x /openvas-check-setup

EXPOSE 4000 9390 9391

RUN greenbone-nvt-sync --verbose
RUN greenbone-scapdata-sync --verbose
RUN greenbone-certdata-sync --verbose

CMD /start
