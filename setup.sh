#!/bin/bash
set -e  # early exit when facing errors

# Verify .env file existence
if [ -f ./.env ]
then
  export $(cat .env | xargs)
else
  echo "Cannot find .env file. Make sure it exists. Use ./.env.example as a reference."
  exit 1
fi

# Verify required environment variables
for var in DATA; do
  if [ -z "${!var}" ]; then
    echo "Missing $var environment variable. Check ./.env file."
    exit 1
  else
    echo "Loaded environment variable: $var=${!var}"
  fi
done

echo "Creating directories..."
mkdir -p "${DATA}"/torrents
mkdir -p "${DATA}"/media/{tv,movies}

echo "Fixing ownership and permissions..."
sudo chown --recursive 1000:1000 "${DATA}"
chmod --recursive +x *-custom-cont-init.d

read -p "Do you want to start Docker Compose? [y/N]" answer
if [[ "$answer" == "y" ]]; then 
  echo "Starting Docker Compose..."
  cd "$(dirname "$0")"
  docker compose -f compose.yaml up -d
fi

