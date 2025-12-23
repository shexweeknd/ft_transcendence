# Grafana Monitoring Service

## Description

Grafana visualization platform for monitoring ft_transcendence infrastructure metrics.

## Access

- **URL**: http://localhost:3001
- **Default Username**: admin
- **Default Password**: admin (change in `.env`)

## Features

- Pre-configured Prometheus datasource
- Auto-provisioned API Gateway dashboard
- Real-time metrics visualization
- Custom dashboard support

## Dashboards

### API Gateway Dashboard
- API Request Rate
- Total API Requests
- Response Time Percentiles (p50, p95)
- Error rates by endpoint

## Configuration

### Datasources
Located in `provisioning/datasources/prometheus.yml`

### Dashboards
Located in `provisioning/dashboards/`
- `dashboard.yml` - Dashboard provider configuration
- `api-gateway.json` - API Gateway dashboard definition

## Custom Dashboards

You can add custom dashboards by:
1. Creating a new JSON file in `provisioning/dashboards/`
2. Restarting the Grafana container

Or create dashboards via the UI (they will be saved in the Grafana volume).

## Environment Variables

- `GF_SECURITY_ADMIN_USER`: Admin username
- `GF_SECURITY_ADMIN_PASSWORD`: Admin password
- `GF_USERS_ALLOW_SIGN_UP`: Allow user registration (default: false)

## Data Persistence

Dashboard state and user configurations are persisted in Docker volume `grafana_data`.
