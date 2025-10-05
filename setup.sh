#!/bin/bash
set -e  # early exit when facing errors

DEPLOYMENT="./deployment"
# Note: order matters, as docker compose -f merges to down.
# Shared resources should at the start of the list.
COMPOSE_FILES=("compose.yaml" "compose.monitor.yaml" "compose.maintenance.yaml" )

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
mkdir -p "${DATA}/media"/{tv,movies}

echo "Ensuring ownership and permissions..."
sudo chown --recursive 1000:1000 "${DATA}"

echo "Ensuing ${DEPLOYMENT} directory..."
mkdir -p "${DEPLOYMENT}"

echo "Copying to deployment directory..."
rm -rf ${DEPLOYMENT}/*
cp -r ${COMPOSE_FILES[@]} .env prometheus.yaml jellyfin ${DEPLOYMENT}

echo "Deploying at ${DEPLOYMENT} with ${COMPOSE_FILES[@]}..."
docker compose --project-directory ${DEPLOYMENT} ${COMPOSE_FILES[@]/#/-f } up -d --remove-orphans

