#!/bin/bash
set -e

BASE_DIR="${HOME}/media-server/data"

echo "Creating directories..."
mkdir -p "${BASE_DIR}"/torrents
mkdir -p "${BASE_DIR}"/media/{tv,movies}

echo "Fixing ownership and permissions..."
chown --recursive 1000:1000 "${BASE_DIR}"
chmod --recursive +x *-custom-cont-init.d

read -p "Do you want to start Docker Compose? [y/N]" answer
if [[ "$answer" == "y" ]]; then 
    echo "Starting Docker Compose..."
    cd "$(dirname "$0")"
    docker compose -f compose.yaml up -d
fi

