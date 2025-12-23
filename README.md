Voici un **README.md complet, structuré comme un véritable cahier des charges DevOps**, destiné à être **consommé par un agent générateur de code** (ou par une équipe humaine) afin de produire **une base de code Docker propre, cohérente et évaluable dans le cadre de *ft_transcendence***.

Le document est volontairement **précis, normatif et non ambigu**.

---

# ft_transcendence – DevOps Infrastructure Specification

*This project has been created as part of the 42 curriculum.*

---

## 1. Purpose of This Document

This README serves as a **technical specification and DevOps blueprint** for generating a **containerized microservices infrastructure** using **Docker and Docker Compose**.

The objective is to define **clear expectations, constraints, and deliverables** so that an automated agent (or developer) can generate a **production-like, reproducible, and explainable infrastructure** compliant with the **ft_transcendence project requirements**.

This document **is not application code**, but a **deployment and orchestration contract**.

---

## 2. High-Level Architecture Overview

The infrastructure is composed of **four isolated microservices**, orchestrated via **Docker Compose**, communicating over a **private Docker network**, and exposed through controlled entry points.

### Microservices:

1. **Frontend Service** – React
2. **API Gateway Service** – FastAPI
3. **Monitoring Service** – Prometheus + Grafana
4. **Secrets Management Service** – HashiCorp Vault

---

## 3. Global Constraints (Non-Negotiable)

The generated infrastructure **MUST** comply with the following:

* ✅ All services **must run in Docker containers**
* ✅ Deployment **must be executable with a single command**
* ✅ No manual setup steps after `docker compose up`
* ✅ Clear service separation (microservices, not a monolith)
* ✅ Secure handling of secrets (no hardcoded credentials)
* ✅ Network isolation between services
* ✅ Deterministic and reproducible builds

---

## 4. Orchestration Requirements

### Docker Compose

* A single `docker-compose.yml` file at the root
* Explicit service definitions
* Explicit networks
* Explicit volumes
* Explicit dependencies (`depends_on`)

### Command to run

```bash
docker compose up --build
```

---

## 5. Services Specification

---

### 5.1 Frontend Microservice – React

#### Responsibilities

* Serve a React frontend application
* Expose the application via HTTP
* Communicate **only** with the API Gateway

#### Requirements

* Dockerized React app
* Multi-stage Dockerfile (build + runtime)
* No direct access to internal services
* Environment-based API URL configuration

#### Expected Ports

* Internal: `3000`
* External: configurable (e.g. `3000:3000`)

#### Constraints

* No secrets inside the frontend container
* No direct Vault or Prometheus access

---

### 5.2 API Gateway Microservice – FastAPI

#### Responsibilities

* Act as **single entry point** for backend traffic
* Route requests to internal services (future extensibility)
* Expose health check endpoints
* Expose Prometheus metrics endpoint

#### Requirements

* FastAPI application
* ASGI server (Uvicorn or equivalent)
* `/health` endpoint
* `/metrics` endpoint (Prometheus-compatible)

#### Security

* Secrets must be fetched from **Vault**
* No secrets stored in `.env` files in production mode

#### Expected Ports

* Internal: `8000`
* External: `8000:8000`

---

### 5.3 Monitoring Microservice – Prometheus + Grafana

#### Responsibilities

* Collect metrics from FastAPI
* Visualize system and application metrics
* Provide dashboards for observability

#### Prometheus

* Scrape FastAPI `/metrics`
* Use static config file mounted as volume
* No dynamic service discovery required

#### Grafana

* Persistent storage for dashboards
* Preconfigured data source (Prometheus)
* Default admin credentials injected via environment variables

#### Expected Ports

* Prometheus: internal only
* Grafana: `3001:3000`

---

### 5.4 Secrets Management Microservice – Vault

#### Responsibilities

* Centralized secrets management
* Secure storage of API secrets and credentials
* Provide secrets to FastAPI at runtime

#### Requirements

* HashiCorp Vault (dev mode acceptable for this project)
* File-based or in-memory backend
* Explicit initialization and unsealing strategy (documented)

#### Constraints

* Vault must **not expose secrets to frontend**
* Vault token must never be committed to Git

#### Expected Ports

* Vault API: `8200:8200`

---

## 6. Networking

### Docker Network

* Single private Docker network
* All services attached
* No service discovery outside Docker DNS

Example:

```yaml
networks:
  transcendence_net:
    driver: bridge
```

---

## 7. Volumes & Persistence

| Service    | Data               |
| ---------- | ------------------ |
| Grafana    | Dashboards & state |
| Prometheus | Metrics data       |
| Vault      | Secrets backend    |

Volumes must be:

* Explicit
* Named
* Documented

---

## 8. Environment Variables & Configuration

### Rules

* `.env` file for local development
* `.env.example` must be provided
* No secrets committed
* Vault used as source of truth

---

## 9. Observability & Health Checks

Each service **must expose**:

* Health status
* Clear logs
* Deterministic startup order

FastAPI must expose:

```http
GET /health
```

Prometheus must scrape:

```http
GET /metrics
```

---

## 10. Security Expectations

* No hardcoded secrets
* No plaintext credentials in Git
* Network isolation
* Principle of least privilege
* Vault as the only secret authority

---

## 11. Deliverables (What the Agent Must Generate)

The agent must generate:

* `docker-compose.yml`
* `frontend/Dockerfile`
* `api-gateway/Dockerfile`
* `prometheus/prometheus.yml`
* `grafana/` provisioning config
* `vault/` configuration
* `.env.example`
* Minimal `README` for each service

---

## 12. Evaluation Readiness (ft_transcendence)

This infrastructure must be:

* Explainable during evaluation
* Runnable on evaluator machine
* Independent of external paid services
* Aligned with DevOps module expectations

---

## 13. Explicit Non-Goals

The following are **out of scope**:

* Kubernetes
* Cloud-specific services (AWS/GCP/Azure)
* CI/CD pipelines
* Production-grade Vault HA setup

---

## 14. Final Note

This DevOps infrastructure is designed to be:

* **Pedagogically sound**
* **Technically defensible**
* **Evaluation-safe**
* **Extensible for future microservices**

---

Si tu veux, je peux maintenant :

* transformer ce README en **prompt optimisé pour un agent IA**
* ou générer **l’arborescence complète du repo**
* ou **valider la conformité exacte avec le module DevOps (2 points)**
