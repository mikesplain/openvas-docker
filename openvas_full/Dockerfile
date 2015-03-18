FROM mikesplain/openvas_base
MAINTAINER Mike Splain mike.splain@gmail.com

RUN rm -rf /etc/my_init.d/000_setup.sh

RUN openvas-mkcert -f -q && \
    ldconfig && \
    openvassd && \
    openvas-nvt-sync --migrate-to-private && \
    openvas-scapdata-sync && \
    openvas-certdata-sync && \
    openvas-mkcert-client -n -i && \
    openvasmd --rebuild --progress && \
    openvasmd --create-user=admin --role=Admin && \
    openvasmd --user=admin --new-password=openvas
