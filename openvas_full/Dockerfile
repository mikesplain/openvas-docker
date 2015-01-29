FROM mikesplain/openvas:base
MAINTAINER Mike Splain mike.splain@gmail.com

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
