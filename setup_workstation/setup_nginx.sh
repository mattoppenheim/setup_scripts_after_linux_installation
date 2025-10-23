#!/bin/bash
# last update 2025_10_21
# Matt Oppenheim

# Installs and configures nginx
# Requires a path to a directory with saved conf files
# Each file in this path will be soft linked to from /etc/nginx/sites-available
# Usage: ./setup_nginx.sh <path to stored conf files>

NGINX_SITES_ENABLED=/etc/nginx/sites-enabled
SITES_ENABLED_TO_USE=$1

if [ -z "$SITES_ENABLED_TO_USE" ]; then
  echo "Usage: $0 <nginx saved sites-enabled conf files directory path>"
  exit 1
fi

# Update and install NGINX
sudo apt update
sudo apt install nginx -y

for file in "$SITES_ENABLED_TO_USE"/*; do
    echo "creating a soft link for $file in $NGINX_SITES_ENABLED "
    sudo ln -s "$file" "$NGINX_SITES_ENABLED"
done

sudo systemctl restart nginx

for file in "$NGINX_SITES_ENABLED"/*; do
    echo "nginx set up for $file"
done

echo "nginx setup completed"
