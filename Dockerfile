# Base image for Odoo
FROM odoo:17.0

# Switch to root user to install dependencies and change file permissions
USER root

# Install necessary dependencies for make
RUN apt-get update && \
    apt-get install -y make build-essential

# Copy your Odoo configuration file
COPY odoo.conf /etc/odoo/odoo.conf

# Copy your custom addons to the appropriate directory
COPY addons /mnt/extra-addons

# Copy Makefile to the container
COPY Makefile /mnt/extra-addons/Makefile

# Create directories for filestore and sessions
RUN mkdir -p /var/lib/odoo/.local/share/Odoo/filestore && \
    mkdir -p /var/lib/odoo/.local/share/Odoo/sessions

# Copy filestore data
COPY filestore /var/lib/odoo/.local/share/Odoo/filestore
COPY filestore/.local/share/Odoo/sessions /var/lib/odoo/.local/share/Odoo/sessions

# Add a custom shell script to initialize the database and then start Odoo
COPY init-db.sh /usr/local/bin/init-db.sh

# Make the script executable (run as root)
RUN chmod +x /usr/local/bin/init-db.sh

# Switch back to the odoo user
USER odoo

# Set the entrypoint to run the initialization script first, then start Odoo
ENTRYPOINT ["/usr/local/bin/init-db.sh"]
