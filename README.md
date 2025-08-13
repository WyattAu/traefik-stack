# Traefik-stack

Traefik setup with a few stacks. Open Portainer.io and copy the docker-compose.yml script with the .env.

## Prerequisites

Before you begin, ensure you have the following:

1. A domain name registered and managed through Cloudflare.
2. A TrueNAS server with Docker and Portainer.io installed and running.
3. A Cloudflare API Token with the correct permissions. To create one:
   - Go to your Cloudflare Dashboard -> My Profile -> API Tokens -> Create Token.
   - Use the "Edit zone DNS" template.
   - Under "Zone Resources," select the specific zone (your domain) you want to use.
   - This creates a token with `Zone:Zone:Read` and `Zone:DNS:Edit` permissions, which is more secure than using a Global API Key.
4. Basic familiarity with the command line for generating secrets.

## 1. Directory Structure

For modularity and ease of management, we will organize our files and data. On your TrueNAS server, create a main directory for your applications (e.g., `/mnt/your-pool/apps`). Inside this directory, create the following structure:

```text
/mnt/your-pool/apps/
├── homelab/
│   ├── .env
│   ├── docker-compose.yml
│   ├── traefik/
│   │   ├── traefik.yml
│   │   ├── rules.yml
│   │   └── acme.json
│   ├── gitea/
│   │   └── data/
│   ├── seafile/
│   │   ├── data/
│   │   └── db/
│   └── authentik/
│       ├── data/
│       ├── geoip/
│       └── templates/
```

## 3. Deployment Steps in Portainer

1. **Create the `proxy` Network**: Before deploying the stack, you must create the Docker network that Traefik will use. In Portainer, go to **Networks** -> **Add network**.

   - **Name**: `proxy`
   - Ensure the correct driver is selected (usually `bridge`).
   - Click **Create the network**.

2. **Create the `acme.json` file**: SSH into your TrueNAS server and run the following commands:

   ```bash
   # Navigate to your traefik directory
   cd /mnt/your-pool/apps/homelab/traefik

   # Create the empty file
   touch acme.json

   # Set restrictive permissions
   chmod 600 acme.json
   ```

3. **Deploy the Stack**:
   - In Portainer, go to **Stacks** -> **Add stack**.
   - **Name**: `homelab`
   - **Build method**: **Web editor**.
   - Copy the entire content of your `docker-compose.yml` file and paste it into the editor.
   - Scroll down to the **Environment variables** section.
   - Click **Load variables from .env file** and upload the `.env` file you created.
   - Click **Deploy the stack**.

Portainer will now pull all the images and start the containers. This may take some time.

## 4. Post-Deployment Configuration

### Seafile First-Time Setup

The Seafile container requires a one-time setup script to be run to initialize its configuration and database structure.

1. In Portainer, go to the `seafile` container's details page and open a **Console** (`>_ Exec console`).
2. Connect as `root`.
3. Run the setup script:

   ```bash
   /opt/seafile/seafile-server-latest/setup-seafile-mysql.sh
   ```

4. The script will ask you several questions.
   - Press Enter to accept the defaults, as most settings are already configured via environment variables.
   - It will initialize the database and create the necessary configuration files inside `${APP_DATA_PATH}/seafile/data`.
5. After the script finishes, **you must restart the Seafile container**. You can do this from the Portainer UI.
6. You can now access Seafile at `https://seafile.your-domain.com`.

### Authentik First-Time Setup

1. Navigate to `https://auth.your-domain.com`.
2. Authentik will guide you through its initial setup wizard to create an admin user (`akadmin`).
3. Once logged in, you can start creating applications, providers, and flows to integrate with your other services. For example, you can replace the basic auth on the Traefik dashboard with a secure OAuth flow from Authentik.

## License

Apache License - see [LICENSE] file.
