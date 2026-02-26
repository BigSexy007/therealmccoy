#!/bin/bash
# Run this once on your VPS to set up the app directory
# Usage: ssh user@vps 'bash -s' < scripts/setup-vps.sh

set -e

APP_DIR="${APP_DIR:-/opt/therealmccoy}"

echo "Creating app directory at $APP_DIR..."
sudo mkdir -p "$APP_DIR"
sudo chown "$USER:$USER" "$APP_DIR"

cd "$APP_DIR"

echo "Creating docker-compose.prod.yml..."
cat > docker-compose.yml << 'EOF'
services:
  app:
    image: ghcr.io/OWNER/therealmccoy:latest
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
    env_file:
      - .env
    restart: unless-stopped
EOF

echo "Creating .env template..."
cat > .env.example << 'EOF'
ANTHROPIC_API_KEY=
AFFINE_URL=
AFFINE_API_KEY=
VECTOR_DB_URL=
EOF

if [ ! -f .env ]; then
  cp .env.example .env
  echo "Created .env file - edit it with your secrets"
fi

echo ""
echo "Setup complete!"
echo ""
echo "Next steps:"
echo "1. Edit $APP_DIR/docker-compose.yml - replace OWNER with your GitHub username"
echo "2. Edit $APP_DIR/.env with your secrets"
echo "3. Add these secrets to GitHub repo settings:"
echo "   - VPS_HOST: your VPS IP or hostname"
echo "   - VPS_USER: SSH username"
echo "   - VPS_SSH_KEY: private key for SSH"
echo "   - VPS_APP_PATH: $APP_DIR"
echo ""
echo "4. Push to main branch to trigger deploy!"
