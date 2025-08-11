#!/bin/bash

set -e

echo "Validating Traefik configuration..."

# Check required files
required_files=(
    "traefik/traefik.yml"
    "traefik/config/middlewares.yml"
    "traefik/config/tls.yml"
    ".env"
)

for file in "${required_files[@]}"; do
    if [ ! -f "$file" ]; then
        echo "Missing required file: $file"
        exit 1
    fi
    echo "Found: $file"
done

# Check .env variables
if [ ! -f .env ]; then
    echo ".env file not found"
    exit 1
fi

# Source .env to check variables
set -a
source .env
set +a

required_vars=(
    "CF_DNS_API_TOKEN"
    "CF_DOMAIN"
    "ACME_EMAIL"
)

for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ] || [[ "${!var}" == *"example"* ]]; then
        echo "Missing or example value for: $var"
        exit 1
    fi
done

# Test Docker Compose files
echo "Testing Docker Compose configurations..."
docker-compose config -q
echo "Main docker-compose validation passed"

# Test service configurations
for svc in services/*/docker-compose.yml; do
    if [ -f "$svc" ]; then
        echo "Testing $svc"
        docker-compose -f "$svc" config -q
    fi
done
echo "Service docker-compose validation passed"

echo "All configuration validation passed"

# Test Traefik configuration (if container is running)
if docker ps | grep -q traefik; then
    echo "Testing Traefik health..."
    docker exec traefik traefik healthcheck --ping
    echo "Traefik is healthy"
fi
