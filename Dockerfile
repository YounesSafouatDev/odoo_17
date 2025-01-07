# Base image for Odoo
FROM odoo:17.0

# Switch to root user to install dependencies and change file permissions
USER root

# Install necessary dependencies for make
RUN apt-get update && \
    apt-get install -y make build-essential

# Create necessary directories if they don't exist
RUN mkdir -p /var/lib/odoo/.local/share/Odoo/sessions && \
    chown -R odoo:odoo /var/lib/odoo/.local/share/Odoo && \
    chmod -R 700 /var/lib/odoo/.local/share/Odoo

# Add a custom shell script to initialize the database and then start Odoo
COPY init-db.sh /usr/local/bin/init-db.sh

# Make the script executable (run as root)
RUN chmod +x /usr/local/bin/init-db.sh

# Switch back to the odoo user
USER odoo

# Set the entrypoint to run the initialization script first, then start Odoo
ENTRYPOINT ["/usr/local/bin/init-db.sh"]
