#!/bin/bash

echo "Generating secure credentials..."

# Generate basic auth
if command -v htpasswd &> /dev/null; then
    echo "Basic Auth Password for admin user:"
    htpasswd -nb admin $(openssl rand -base64 16)
    echo ""
fi

# Generate secret key
echo "Secret Key:"
openssl rand -hex 32
echo ""

# Generate database passwords
echo "Database Password:"
openssl rand -base64 32
echo ""

echo "JWT Secret:"
openssl rand -hex 32
echo ""

echo "Copy these to your .env file as needed"
