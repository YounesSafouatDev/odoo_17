# Base image for Odoo
FROM odoo:17.0

# Copy your configuration file
COPY odoo.conf /etc/odoo/odoo.conf

# Copy your custom addons
COPY addons /mnt/extra-addons

# Set the filestore path
RUN mkdir -p /var/lib/odoo/.local/share/Odoo/filestore && \
    mkdir -p /var/lib/odoo/.local/share/Odoo/sessions

COPY filestore /var/lib/odoo/.local/share/Odoo/filestore
COPY filestore/.local/share/Odoo/sessions /var/lib/odoo/.local/share/Odoo/sessions

# Run Odoo
CMD ["odoo"]
