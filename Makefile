# Host-side Makefile: manages the dev container.
# Run these from your machine, not from inside the container.

COMPOSE := docker compose
SERVICE := rust

# Pass your UID/GID to the build so files you create aren't owned by root
export USER_UID := $(shell id -u)
export USER_GID := $(shell id -g)

.DEFAULT_GOAL := help
.PHONY: help dev stop clean

help: ## Show available commands
	@grep -hE '^[a-zA-Z_-]+:.*## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*## "}; {printf "  \033[36m%-8s\033[0m %s\n", $$1, $$2}'

dev: ## Build (if needed), start the container, and open a shell in it
	$(COMPOSE) up -d --build
	$(COMPOSE) exec $(SERVICE) bash || true

stop: ## Stop the container (keeps image, volumes, and network)
	$(COMPOSE) stop

clean: ## Remove container, network, image, and cache volumes
	$(COMPOSE) down --rmi all --volumes --remove-orphans
