# Variables
DOCKER_COMPOSE = docker-compose
COMPOSE_FILE = ./docker-compose.yml
SERVICE = $(shell basename $(PWD))-web-1
DB_SERVICE = mydb
DB_NAME = odoo_17
DB_USER = younes
DB_PASSWORD = Bst.987654321*

.PHONY: help
help:
	@echo "Available commands:"
	@echo "  up          - Start containers in detached mode"
	@echo "  down        - Stop and remove containers"
	@echo "  restart     - Restart the Odoo container"
	@echo "  rebuild     - Rebuild the Odoo service"
	@echo "  logs        - View logs of the Odoo container"
	@echo "  logs-db     - View logs of the database container"
	@echo "  clean       - Remove all containers, volumes, and images"
	@echo "  init-db     - Initialize the database with the base module"

# Start containers
.PHONY: up
up:
	@$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) up -d

# Stop and remove containers
.PHONY: down
down:
	@$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) down

# Restart the Odoo container
.PHONY: restart
restart:
	@$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) restart $(SERVICE)

# Rebuild the Odoo container (after code changes)
.PHONY: rebuild
rebuild:
	@$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) stop $(SERVICE)
	@$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) build $(SERVICE)
	@$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) up -d $(SERVICE)

# View logs of the Odoo container
.PHONY: logs
logs:
	@$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) logs -f $(SERVICE)

# View logs of the database container
.PHONY: logs-db
logs-db:
	@$(DOCKER_COMPOSE) -f $(COMPOSE_FILE) logs -f $(DB_SERVICE)

# Initialize the database with the base module
.PHONY: init-db
init-db:
	@echo "Initializing database with the base module..."
	@docker exec -it $(SERVICE) odoo -d $(DB_NAME) -i base --db_host=$(DB_SERVICE) --db_user=$(DB_USER) --db_password=$(DB_PASSWORD) --without-demo=all
	@echo "Running initialization command with --stop-after-init..."
	@docker exec -it $(SERVICE) odoo -d $(DB_NAME) --init=base --stop-after-init

# Clean everything (use cautiously)
.PHONY: clean
clean:
	@echo "WARNING: This will remove containers, volumes, and images. Proceed with caution!"
	@read -p "Are you sure you want to proceed? (y/n) " confirm && [ $ = "y" ] && $(DOCKER_COMPOSE) -f $(COMPOSE_FILE) down --volumes --rmi all && @echo "Removed containers, volumes, and images." || @echo "Clean operation canceled."
