#!/bin/bash
set -e  # early exit when facing errors

DEPLOYMENT="./deployment"
echo "Loading .env from: ${DEPLOYMENT}/.env"
export $(cat "${DEPLOYMENT}/.env" | xargs)

echo "===== Backups Status ====="
tree ${LOCAL_BACKUP} -h --du

