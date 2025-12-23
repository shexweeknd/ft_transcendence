# Frontend Service - React

## Description

React-based frontend application for ft_transcendence DevOps infrastructure.

## Features

- Multi-stage Docker build (optimized for production)
- Nginx web server for static content
- Health check endpoint
- API Gateway integration
- Real-time service status monitoring

## Local Development

```bash
npm install
npm start
```

## Build

```bash
npm run build
```

## Docker

Build and run:

```bash
docker build -t ft-transcendence-frontend .
docker run -p 3000:3000 ft-transcendence-frontend
```

## Environment Variables

- `REACT_APP_API_URL`: API Gateway URL (default: http://localhost:8000)

## Endpoints

- `/`: Main application
- `/health`: Health check (nginx)
