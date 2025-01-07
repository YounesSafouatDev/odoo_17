# Base image for Odoo
FROM odoo:17.0

# Install make (and other necessary tools like build-essential if needed)
RUN apt-get update && \
    apt-get install -y make build-essential

# Copy your Odoo configuration file
COPY odoo.conf /etc/odoo/odoo.conf

# Copy your custom addons to the appropriate directory
COPY addons /mnt/extra-addons

# Create directories for filestore and sessions
RUN mkdir -p /var/lib/odoo/.local/share/Odoo/filestore && \
    mkdir -p /var/lib/odoo/.local/share/Odoo/sessions

# Copy filestore data
COPY filestore /var/lib/odoo/.local/share/Odoo/filestore
COPY filestore/.local/share/Odoo/sessions /var/lib/odoo/.local/share/Odoo/sessions

# Set environment variables if needed (optional, depending on your setup)
# ENV DB_HOST=mydb
# ENV DB_USER=younes
# ENV DB_PASSWORD=Bst.987654321*

# Run Odoo (you can add specific commands for initialization here if needed)
CMD ["make", "init-db", ";", "python", "odoo-bin"]
