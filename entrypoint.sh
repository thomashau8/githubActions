#!/bin/bash
set -e

echo "Checking SECRET_KEY for entrypoint check: [${SECRET_KEY}]"
echo "Checking DATABASE_URL for entrypoint check: [${DATABASE_URL}]"

if [ -z "${DATABASE_URL}" ] || [ -z "${SECRET_KEY}" ]; then
  echo "ENTRYPOINT CHECK FAILED: DATABASE_URL or SECRET_KEY is empty or unset."
  exit 1
fi

# Check storage variables
if [ -z "${AZURE_ACCOUNT_NAME}" ] || [ -z "${AZURE_ACCOUNT_KEY}" ] || [ -z "${AZURE_CONTAINER}" ]; then
  echo "ENTRYPOINT CHECK FAILED: Azure Storage environment variables are required."
  exit 1
fi

echo "Starting Gunicorn..."
exec gunicorn --bind=0.0.0.0:8000 config.wsgi:application