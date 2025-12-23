.PHONY: help up down restart logs clean rebuild status health

# Colors for output
GREEN = \033[0;32m
YELLOW = \033[0;33m
RED = \033[0;31m
NC = \033[0m # No Color

# Docker Compose command (try with hyphen if default fails)
DOCKER_COMPOSE := $(shell echo "docker compose")

help: ## Show this help message
	@echo "$(GREEN)ft_transcendence - DevOps Infrastructure$(NC)"
	@echo ""
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-15s$(NC) %s\n", $$1, $$2}'

up: ## Start all services
	@echo "$(GREEN)Starting ft_transcendence infrastructure...$(NC)"
	@echo "$(YELLOW)Building images...$(NC)"
	$(DOCKER_COMPOSE) build
	@echo "$(YELLOW)Starting services...$(NC)"
	$(DOCKER_COMPOSE) up -d
	@echo "$(GREEN)Services started successfully!$(NC)"
	@echo ""
	@echo "Access points:"
	@echo "  - Frontend:    http://localhost:3000"
	@echo "  - API Gateway: http://localhost:8000"
	@echo "  - Grafana:     http://localhost:3001"
	@echo "  - Vault:       http://localhost:8200"

up-fg: ## Start all services in foreground (with logs)
	@echo "$(GREEN)Starting ft_transcendence infrastructure in foreground...$(NC)"
	$(DOCKER_COMPOSE) build
	$(DOCKER_COMPOSE) up

down: ## Stop all services
	@echo "$(YELLOW)Stopping all services...$(NC)"
	$(DOCKER_COMPOSE) down
	@echo "$(GREEN)Services stopped.$(NC)"

restart: down up ## Restart all services

logs: ## Show logs from all services
	$(DOCKER_COMPOSE) logs -f

logs-api: ## Show API Gateway logs
	$(DOCKER_COMPOSE) logs -f api-gateway

logs-frontend: ## Show Frontend logs
	$(DOCKER_COMPOSE) logs -f frontend

logs-prometheus: ## Show Prometheus logs
	$(DOCKER_COMPOSE) logs -f prometheus

logs-grafana: ## Show Grafana logs
	$(DOCKER_COMPOSE) logs -f grafana

logs-vault: ## Show Vault logs
	$(DOCKER_COMPOSE) logs -f vault

clean: ## Stop services and remove volumes
	@echo "$(YELLOW)Cleaning up containers, networks, and volumes...$(NC)"
	$(DOCKER_COMPOSE) down -v
	@echo "$(GREEN)Cleanup complete.$(NC)"

fclean: clean ## Full cleanup including images
	@echo "$(RED)Removing all Docker images...$(NC)"
	$(DOCKER_COMPOSE) down -v --rmi all
	@echo "$(GREEN)Full cleanup complete.$(NC)"

rebuild: clean up ## Clean rebuild of all services

status: ## Show status of all services
	@echo "$(GREEN)Service Status:$(NC)"
	@$(DOCKER_COMPOSE) ps

health: ## Check health of all services
	@echo "$(GREEN)Checking service health...$(NC)"
	@echo ""
	@echo "$(YELLOW)API Gateway:$(NC)"
	@curl -s http://localhost:8000/health | jq . || echo "$(RED)Not responding$(NC)"
	@echo ""
	@echo "$(YELLOW)Prometheus:$(NC)"
	@curl -s http://localhost:9090/-/healthy && echo "$(GREEN)OK$(NC)" || echo "$(RED)Not responding$(NC)"
	@echo ""
	@echo "$(YELLOW)Grafana:$(NC)"
	@curl -s http://localhost:3001/api/health | jq . || echo "$(RED)Not responding$(NC)"
	@echo ""
	@echo "$(YELLOW)Vault:$(NC)"
	@curl -s http://localhost:8200/v1/sys/health | jq . || echo "$(RED)Not responding$(NC)"

init-vault: ## Initialize Vault (run after first startup)
	@echo "$(GREEN)Initializing Vault...$(NC)"
	@echo "This will output root token and unseal keys - SAVE THEM SECURELY!"
	@echo ""
	$(DOCKER_COMPOSE) exec vault vault operator init -key-shares=1 -key-threshold=1

unseal-vault: ## Unseal Vault (requires unseal key)
	@echo "$(YELLOW)Enter unseal key:$(NC)"
	@read UNSEAL_KEY && $(DOCKER_COMPOSE) exec vault vault operator unseal $$UNSEAL_KEY

shell-api: ## Open shell in API Gateway container
	$(DOCKER_COMPOSE) exec api-gateway sh

shell-frontend: ## Open shell in Frontend container
	$(DOCKER_COMPOSE) exec frontend sh

shell-vault: ## Open shell in Vault container
	$(DOCKER_COMPOSE) exec vault sh

prune: ## Remove all unused Docker resources
	@echo "$(RED)WARNING: This will remove all unused Docker resources!$(NC)"
	@echo "Press Ctrl+C to cancel, Enter to continue..."
	@read
	docker system prune -af --volumes

dev: ## Start only essential services for development
	$(DOCKER_COMPOSE) up frontend api-gateway vault -d

.DEFAULT_GOAL := help
