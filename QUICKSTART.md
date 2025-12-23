# ft_transcendence - Quick Start Guide

## Prerequisites

- Docker
- Docker Compose
- Make (optional, but recommended)

## Quick Start

1. **Clone and setup**
   ```bash
   # Copy environment template
   cp .env.example .env
   ```

2. **Start all services**
   ```bash
   make up
   # Or without Make:
   docker compose up --build -d
   ```

3. **Access the services**
   - **Frontend**: http://localhost:3000
   - **API Gateway**: http://localhost:8000
   - **API Docs**: http://localhost:8000/docs
   - **Prometheus**: http://localhost:9090
   - **Grafana**: http://localhost:3001 (admin/admin)
   - **Vault**: http://localhost:8200 (token: dev-root-token)

## Available Commands

```bash
make help          # Show all available commands
make up            # Start all services
make down          # Stop all services
make restart       # Restart all services
make logs          # Show logs from all services
make clean         # Stop and remove volumes
make rebuild       # Clean rebuild
make status        # Show service status
make health        # Check health of all services
```

## Service-Specific Logs

```bash
make logs-frontend
make logs-api
make logs-prometheus
make logs-grafana
make logs-vault
```

## Architecture

```
┌─────────────┐
│   Frontend  │ :3000
│   (React)   │
└──────┬──────┘
       │
       ▼
┌─────────────┐     ┌─────────────┐
│ API Gateway │────▶│  Prometheus │ :9090
│  (FastAPI)  │ :8000└──────┬──────┘
└──────┬──────┘            │
       │                   ▼
       ▼              ┌─────────────┐
┌─────────────┐      │   Grafana   │ :3001
│    Vault    │      │             │
│             │ :8200└─────────────┘
└─────────────┘
```

## Development

### Frontend Development
```bash
cd frontend
npm install
npm start
```

### API Development
```bash
cd api-gateway
pip install -r requirements.txt
python main.py
```

## Troubleshooting

### Services not starting
```bash
# Check logs
make logs

# Check service status
docker compose ps
```

### Port conflicts
Modify port mappings in `docker-compose.yml` if ports are already in use.

### Clean restart
```bash
make fclean  # Full cleanup including images
make up      # Start fresh
```

## Security Notes

⚠️ **This is a development setup. Before production:**
- Change all default passwords
- Enable TLS/SSL
- Use proper Vault authentication
- Implement network security policies
- Review and harden all configurations

## Project Structure

```
ft_transcendence/
├── Makefile                    # Build automation
├── docker-compose.yml          # Service orchestration
├── .env.example                # Environment template
├── frontend/                   # React application
│   ├── Dockerfile
│   ├── nginx.conf
│   └── src/
├── api-gateway/                # FastAPI application
│   ├── Dockerfile
│   ├── requirements.txt
│   └── main.py
├── prometheus/                 # Monitoring config
│   └── prometheus.yml
├── grafana/                    # Grafana provisioning
│   └── provisioning/
└── vault/                      # Vault configuration
    ├── config/
    └── scripts/
```

## Next Steps

1. Explore the API documentation at http://localhost:8000/docs
2. Check the Grafana dashboard at http://localhost:3001
3. Review Prometheus metrics at http://localhost:9090
4. Customize the services for your needs

## Documentation

Each service has its own README with detailed information:
- [Frontend README](./frontend/README.md)
- [API Gateway README](./api-gateway/README.md)
- [Prometheus README](./prometheus/README.md)
- [Grafana README](./grafana/README.md)
- [Vault README](./vault/README.md)

## License

This project is part of the 42 School curriculum.
