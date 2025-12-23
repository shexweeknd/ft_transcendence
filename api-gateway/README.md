# API Gateway Service - FastAPI

## Description

FastAPI-based API Gateway for ft_transcendence with Prometheus metrics and Vault integration.

## Features

- RESTful API with FastAPI
- Health check endpoint (`/health`)
- Prometheus metrics endpoint (`/metrics`)
- Vault integration for secrets management
- CORS middleware
- Automatic API documentation (`/docs`)

## Endpoints

### Core
- `GET /` - Root endpoint
- `GET /health` - Health check
- `GET /metrics` - Prometheus metrics

### API
- `GET /api/status` - Detailed API status
- `GET /api/info` - System information
- `GET /api/vault/status` - Vault connection status

### Documentation
- `GET /docs` - Swagger UI
- `GET /redoc` - ReDoc documentation

## Environment Variables

- `VAULT_ADDR`: Vault server address
- `VAULT_TOKEN`: Vault authentication token
- `ENVIRONMENT`: Deployment environment (development/production)

## Local Development

```bash
pip install -r requirements.txt
python main.py
```

Or with uvicorn:

```bash
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

## Docker

```bash
docker build -t ft-transcendence-api .
docker run -p 8000:8000 ft-transcendence-api
```

## Metrics

The API exposes Prometheus metrics including:
- `api_requests_total`: Total number of requests
- `api_request_duration_seconds`: Request duration histogram

## Security

Secrets are managed through HashiCorp Vault. Never commit secrets to version control.
