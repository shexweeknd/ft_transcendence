# Prometheus Monitoring Service

## Description

Prometheus time-series database for collecting and storing metrics from the API Gateway and other services.

## Configuration

The `prometheus.yml` file defines:
- Scrape intervals
- Target services
- Labels and metadata

## Monitored Services

1. **Prometheus** (self-monitoring) - `localhost:9090`
2. **API Gateway** - `api-gateway:8000/metrics`

## Accessing Prometheus

- Web UI: http://localhost:9090
- Targets: http://localhost:9090/targets
- Graph: http://localhost:9090/graph

## Example Queries

### API Request Rate
```promql
rate(api_requests_total[5m])
```

### Request Duration (95th percentile)
```promql
histogram_quantile(0.95, rate(api_request_duration_seconds_bucket[5m]))
```

### Total Requests by Endpoint
```promql
sum(api_requests_total) by (endpoint)
```

## Data Retention

By default, Prometheus stores data for 15 days. Configure via command-line flags in `docker-compose.yml`.

## Integration

Prometheus is configured as a data source in Grafana for visualization.
