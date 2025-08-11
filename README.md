# traefik-stack

A Traefik v3 reverse proxy setup with Cloudflare integration.

## Features

- **Cloudflare DDNS** integration
- **Let's Encrypt SSL** certificates
- **Security Headers** and rate limiting
- **Authentik** authentication system
- **Gitea** Git service
- **Seafile** document management

## Quick Start

1. **Clone the repository:**

   ```bash
   git clone https://github.com/WyattAu/traefik-stack.git
   cd traefik-stack
   ```

2. **Run setup script:**

   ```bash
   chmod +x scripts/setup.sh
   ./scripts/setup.sh
   ```

3. **Configure environment:**

   ```bash
   cp .env.example .env
   # Edit .env with your values
   ```

4. **Generate passwords:**

   ```bash
   chmod +x scripts/generate-passwords.sh
   ./scripts/generate-passwords.sh
   ```

5. **Validate configuration:**

   ```bash
   chmod +x scripts/validate-config.sh
   ./scripts/validate-config.sh
   ```

6. **Deploy:**

   ```bash
   docker compose up -d
   ```

## Configuration

Update `.env` file with your values, then deploy each service:

```bash
# Deploy main Traefik
docker compose up -d

# Deploy services individually
docker compose -f services/gitea/docker-compose.yml up -d
docker compose -f services/authentik/docker-compose.yml up -d
docker compose -f services/seafile/docker-compose.yml up -d
```

## Directory Structure

```bash
traefik-stack/
├── .github/
│   └── workflows/
│       └── test-deploy.yml
├── .env.example
├── docker-compose.yml
├── traefik/
│   ├── traefik.yml
│   ├── acme.json
│   └── config/
│       ├── middlewares.yml
│       ├── tls.yml
│       └── dynamic.yml
├── services/
│   ├── gitea/
│   │   └── docker-compose.yml
│   ├── authentik/
│   │   └── docker-compose.yml
│   └── seafile/
│       └── docker-compose.yml
├── scripts/
│   ├── setup.sh
│   ├── validate-config.sh
│   └── generate-passwords.sh
└── README.md
```

## License

Apache License - see [LICENSE] file.
