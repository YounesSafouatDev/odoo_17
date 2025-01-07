
FROM odoo:17.0


USER root


RUN apt-get update && \
    apt-get install -y make build-essential


COPY odoo.conf /etc/odoo/odoo.conf


COPY addons /mnt/extra-addons


RUN mkdir -p /var/lib/odoo/.local/share/Odoo/filestore && \
    mkdir -p /var/lib/odoo/.local/share/Odoo/sessions


COPY filestore /var/lib/odoo/.local/share/Odoo/filestore
COPY filestore/.local/share/Odoo/sessions /var/lib/odoo/.local/share/Odoo/sessions


CMD ["make", "init-db", ";", "python", "odoo-bin"]
