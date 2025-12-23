# HashiCorp Vault - Secrets Management

## Description

HashiCorp Vault service for centralized secrets management in ft_transcendence.

## Access

- **URL**: http://localhost:8200
- **Dev Root Token**: `dev-root-token` (configured in `.env`)

## ⚠️ Important: Dev Mode

This Vault instance runs in **development mode** for the ft_transcendence project. In dev mode:
- Vault starts unsealed
- In-memory storage (unless file backend configured)
- TLS disabled
- **NOT suitable for production**

## Initialization

### Automatic (Dev Mode)
The Vault container starts with a predefined root token in dev mode.

### Manual Initialization (Production-like)

```bash
# Initialize Vault
make init-vault

# Save the unseal keys and root token securely!

# Unseal Vault
make unseal-vault
```

Or use the initialization script:

```bash
docker compose exec vault sh /vault/scripts/init-vault.sh
```

## Features

- KV Secrets Engine v2
- Web UI enabled
- File-based storage backend
- Sample secrets pre-populated

## Secrets Structure

### API Gateway Secrets
Path: `secret/api-gateway`
- `api_key`: API authentication key
- `database_url`: Database connection string
- `jwt_secret`: JWT signing secret

### Application Secrets
Path: `secret/app`
- `app_name`: Application name
- `environment`: Deployment environment
- `version`: Application version

## Using Vault CLI

```bash
# Access Vault container
docker compose exec vault sh

# Login
vault login <root-token>

# Read a secret
vault kv get secret/api-gateway

# Write a secret
vault kv put secret/my-service key=value

# List secrets
vault kv list secret/
```

## Integration with API Gateway

The API Gateway can fetch secrets from Vault using the `hvac` Python library:

```python
import hvac

client = hvac.Client(
    url='http://vault:8200',
    token=os.getenv('VAULT_TOKEN')
)

secret = client.secrets.kv.v2.read_secret_version(path='api-gateway')
api_key = secret['data']['data']['api_key']
```

## Environment Variables

- `VAULT_DEV_ROOT_TOKEN_ID`: Root token for dev mode
- `VAULT_DEV_LISTEN_ADDRESS`: Listen address (0.0.0.0:8200)

## Security Notes

1. **Never commit real secrets to Git**
2. **Change default tokens in production**
3. **Use proper authentication methods (AppRole, Kubernetes auth, etc.)**
4. **Enable TLS in production**
5. **Implement proper access policies**
6. **Rotate secrets regularly**

## Data Persistence

Vault data is persisted in the `vault_data` Docker volume when using file storage backend.

## Troubleshooting

### Vault is sealed
```bash
make unseal-vault
# Or manually:
vault operator unseal <unseal-key>
```

### Cannot connect
- Ensure Vault container is running: `docker compose ps`
- Check logs: `make logs-vault`

### Lost root token
If running in dev mode, the token is `dev-root-token`. Otherwise, you need to re-initialize (will lose all data).
