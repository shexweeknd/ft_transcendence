#!/bin/sh
# Vault initialization script for ft_transcendence
# This script initializes Vault and creates sample secrets

set -e

echo "==================================="
echo "Vault Initialization Script"
echo "==================================="

# Wait for Vault to be ready
echo "Waiting for Vault to be ready..."
sleep 5

# Check if Vault is initialized
INIT_STATUS=$(vault status -format=json | jq -r '.initialized')

if [ "$INIT_STATUS" = "false" ]; then
    echo "Initializing Vault..."
    vault operator init -key-shares=1 -key-threshold=1 > /tmp/vault-init.txt
    
    echo ""
    echo "==================================="
    echo "IMPORTANT: Save these credentials!"
    echo "==================================="
    cat /tmp/vault-init.txt
    echo "==================================="
    echo ""
    
    # Extract unseal key and root token
    UNSEAL_KEY=$(grep 'Unseal Key 1:' /tmp/vault-init.txt | awk '{print $NF}')
    ROOT_TOKEN=$(grep 'Initial Root Token:' /tmp/vault-init.txt | awk '{print $NF}')
    
    # Unseal Vault
    echo "Unsealing Vault..."
    vault operator unseal "$UNSEAL_KEY"
    
    # Login with root token
    vault login "$ROOT_TOKEN"
    
    echo "Vault initialized and unsealed successfully!"
else
    echo "Vault is already initialized."
fi

# Enable KV secrets engine if not already enabled
echo "Enabling KV secrets engine..."
vault secrets enable -path=secret kv-v2 2>/dev/null || echo "KV engine already enabled"

# Create sample secrets
echo "Creating sample secrets..."
vault kv put secret/api-gateway \
    api_key="sample-api-key-12345" \
    database_url="postgresql://user:pass@db:5432/transcendence" \
    jwt_secret="super-secret-jwt-key"

echo "Creating application secrets..."
vault kv put secret/app \
    app_name="ft_transcendence" \
    environment="production" \
    version="1.0.0"

echo ""
echo "==================================="
echo "Vault setup complete!"
echo "==================================="
echo ""
echo "Access Vault at: http://localhost:8200"
echo "Use the root token to login."
echo ""
