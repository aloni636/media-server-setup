#!/bin/bash
set -e

BASE_DIR="${HOME}/media-server"

echo "Creating folders..."
mkdir -p "${BASE_DIR}"/{downloads,tv,movies}

echo "Fixing ownership..."
chown -R 1000:1000 "${BASE_DIR}"
chmod --recursive +x *-custom-cont-init.d

read -p "Do you want to start Docker Compose? [y/N]" answer
if [[ "$answer" == "y" ]]; then 
    echo "Starting Docker Compose..."
    cd "$(dirname "$0")"
    docker compose -f compose.yaml up -d
fi

