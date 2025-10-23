#!/bin/bash

# Usage: ./setup_ssl.sh <domain> <email>

DOMAIN=$1
EMAIL=$2

if [ -z "$DOMAIN" ] || [ -z "$EMAIL" ]; then
  echo "Usage: $0 <domain> <email>"
  exit 1
fi

# Install Certbot
sudo apt update
sudo apt install certbot python3-certbot-nginx -y

# Obtain SSL certificate
sudo certbot --nginx --non-interactive --agree-tos --redirect -d $DOMAIN -m $EMAIL

# Reload NGINX to apply SSL settings
sudo systemctl reload nginx
echo "SSL setup for $DOMAIN is complete."
