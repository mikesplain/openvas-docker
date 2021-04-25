FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -yq \
      wget \
      curl \
      build-essential \
      sudo \
      systemctl \
      cron

# TODO: Remove after Dev
RUN apt-get install mlocate -yq


RUN wget https://raw.githubusercontent.com/yu210148/gvm_install/master/install_gvm.sh && \
  chmod +x install_gvm.sh

ADD https://github.com/just-containers/s6-overlay/releases/download/v2.2.0.1/s6-overlay-amd64-installer /tmp/
RUN chmod +x /tmp/s6-overlay-amd64-installer && /tmp/s6-overlay-amd64-installer /
ENTRYPOINT ["/init"]

ADD install.sh /
RUN /install.sh

# TODO: Move to install.sh
ADD install-gvm.sh /
USER gvm
RUN /install-gvm.sh
USER root
RUN ldconfig

RUN chown gvm:gvm /var/run/redis/ && \
  chmod 775 -R /etc/postgresql

COPY rootfs /

# TODO: Remove after Dev
RUN updatedb
ENV S6_KILL_GRACETIME 0; \
    PKG_CONFIG_PATH /opt/gvm/lib/pkgconfig:$PKG_CONFIG_PATH
# TODO: Add non-root support
# USER gvm