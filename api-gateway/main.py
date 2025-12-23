"""
ft_transcendence API Gateway
FastAPI application with health checks and Prometheus metrics
"""

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import PlainTextResponse
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST
import time
import os
from datetime import datetime

# Initialize FastAPI app
app = FastAPI(
    title="ft_transcendence API Gateway",
    description="API Gateway for ft_transcendence DevOps Infrastructure",
    version="1.0.0"
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify exact origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Prometheus metrics
REQUEST_COUNT = Counter(
    'api_requests_total',
    'Total API requests',
    ['method', 'endpoint', 'status']
)

REQUEST_DURATION = Histogram(
    'api_request_duration_seconds',
    'API request duration in seconds',
    ['method', 'endpoint']
)

# Startup time
STARTUP_TIME = datetime.now()

# Middleware for metrics
@app.middleware("http")
async def metrics_middleware(request, call_next):
    start_time = time.time()
    response = await call_next(request)
    duration = time.time() - start_time
    
    REQUEST_COUNT.labels(
        method=request.method,
        endpoint=request.url.path,
        status=response.status_code
    ).inc()
    
    REQUEST_DURATION.labels(
        method=request.method,
        endpoint=request.url.path
    ).observe(duration)
    
    return response

@app.get("/")
async def root():
    """Root endpoint"""
    return {
        "service": "ft_transcendence API Gateway",
        "version": "1.0.0",
        "status": "running",
        "uptime": str(datetime.now() - STARTUP_TIME)
    }

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {
        "status": "healthy",
        "timestamp": datetime.now().isoformat(),
        "service": "api-gateway",
        "environment": os.getenv("ENVIRONMENT", "development"),
        "vault_configured": bool(os.getenv("VAULT_ADDR"))
    }

@app.get("/metrics")
async def metrics():
    """Prometheus metrics endpoint"""
    return PlainTextResponse(
        generate_latest(),
        media_type=CONTENT_TYPE_LATEST
    )

@app.get("/api/status")
async def api_status():
    """API status with detailed information"""
    return {
        "api_gateway": "operational",
        "uptime": str(datetime.now() - STARTUP_TIME),
        "timestamp": datetime.now().isoformat(),
        "services": {
            "vault": {
                "configured": bool(os.getenv("VAULT_ADDR")),
                "address": os.getenv("VAULT_ADDR", "not configured")
            },
            "prometheus": {
                "enabled": True,
                "endpoint": "/metrics"
            }
        }
    }

@app.get("/api/info")
async def info():
    """System information"""
    return {
        "name": "ft_transcendence",
        "description": "DevOps Infrastructure - API Gateway",
        "architecture": "microservices",
        "services": [
            "frontend (React)",
            "api-gateway (FastAPI)",
            "monitoring (Prometheus + Grafana)",
            "secrets (HashiCorp Vault)"
        ],
        "endpoints": {
            "health": "/health",
            "metrics": "/metrics",
            "status": "/api/status",
            "docs": "/docs",
            "redoc": "/redoc"
        }
    }

# Example endpoint with Vault integration (placeholder)
@app.get("/api/vault/status")
async def vault_status():
    """Check Vault connection status"""
    vault_addr = os.getenv("VAULT_ADDR")
    vault_token = os.getenv("VAULT_TOKEN")
    
    if not vault_addr:
        return {
            "status": "not configured",
            "message": "VAULT_ADDR not set"
        }
    
    # In a real implementation, you would use hvac to check Vault status
    return {
        "status": "configured",
        "address": vault_addr,
        "token_present": bool(vault_token)
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
