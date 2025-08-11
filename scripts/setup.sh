#!/bin/bash

set -e

echo "Setting up Traefik v3 Stack..."

# Create required directories
echo "Creating directories..."
mkdir -p traefik/{config,logs}
mkdir -p services/{gitea,gitea/data,authentik/{database,redis,media},seafile/{db,seafile-data}}
touch traefik/acme.json
chmod 600 traefik/acme.json

# Create docker network
echo "Creating Docker network..."
docker network create traefik_network 2>/dev/null || echo "Network already exists"

# Check for .env file
if [ ! -f .env ]; then
    echo ".env file not found. Copying from .env.example..."
    cp .env.example .env
    echo "Please update .env with your configuration values!"
fi

# Generate basic auth if not present
if ! grep -q "BASIC_AUTH_PASSWORD_HASH.*[^example]" .env; then
    echo "Generating basic auth for Traefik dashboard..."
    if command -v htpasswd &> /dev/null; then
        BASIC_AUTH_HASH="admin:$$(openssl passwd -apr1 changeme)"
        sed -i.bak "s/BASIC_AUTH_PASSWORD_HASH=.*/BASIC_AUTH_PASSWORD_HASH=${BASIC_AUTH_HASH}/" .env
        echo "Basic auth generated"
    else
        echo "htpasswd not found. Please install apache2-utils or generate basic auth manually"
    fi
fi

# Validate configuration
echo "Setup completed successfully!"
echo ""
echo "Next steps:"
echo "1. Update .env with your configuration values"
echo "2. Run: docker compose up -d"
echo "3. Monitor logs: docker compose logs -f traefik"
