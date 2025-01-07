# Base image for Odoo
FROM odoo:17.0

# Copy your Odoo configuration file
COPY odoo.conf /etc/odoo/odoo.conf

# Copy your custom addons to the appropriate directory
COPY addons /mnt/extra-addons

# Copy Makefile to the container (ensure it's in the right location)
COPY Makefile /mnt/extra-addons/Makefile

# Create directories for filestore and sessions
RUN mkdir -p /var/lib/odoo/.local/share/Odoo/filestore && \
    mkdir -p /var/lib/odoo/.local/share/Odoo/sessions

# Copy filestore data
COPY filestore /var/lib/odoo/.local/share/Odoo/filestore
COPY filestore/.local/share/Odoo/sessions /var/lib/odoo/.local/share/Odoo/sessions

# Install necessary dependencies for make
RUN apt-get update && \
    apt-get install -y make build-essential

# Run Odoo (add make init-db to initialize the database)
CMD ["make", "init-db", ";", "python", "odoo-bin"]
