#!/bin/bash
set -e  # early exit when facing errors

DEPLOYMENT="./deployment"

# Verify .env file existence
if [ ! -f ./.env ]
then
  echo "Cannot find ./.env file. Create it and use ./.env.example for reference."
  exit 1
fi

# load and validate
echo "Validating environment variables..."
export $(cat .env | xargs)

# see https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion
function check_var { : "${!1:?missing $1}"; }

check_var DATA
check_var COMPOSE_PROJECT_NAME
check_var TZ
check_var LOCAL_BACKUP

echo "Ensuring directories in ${DATA}..."
mkdir -p "${DATA}/torrents"
mkdir -p "${DATA}/media/{tv,movies}"

echo "Ensuring ownership and permissions..."
sudo chown --recursive 1000:1000 "${DATA}"

echo "Ensuing ${DEPLOYMENT} directory..."
mkdir -p "${DEPLOYMENT}"

echo "Copying to deployment directory..."
rm -rf ${DEPLOYMENT}/*
cp -r compose.yaml .env ./secrets ${DEPLOYMENT}

echo "Starting Docker Compose at ${DEPLOYMENT}..."
# docker compose automatically picks up changes and recreate only the necessary containers
# see https://docs.docker.com/reference/cli/docker/compose/up/#description
docker compose --project-directory ${DEPLOYMENT} -f compose.yaml up -d

