#!/bin/bash
set -euo pipefail

BITCAST_DIR=${BITCAST_DIR:-/home/ubuntu/bitcast}
BITCAST_X_DIR=${BITCAST_X_DIR:-/home/ubuntu/bitcast-x}
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
MASTER_ENV="${MASTER_ENV:-$REPO_ROOT/.env}"

usage() {
  echo "Usage: $0"
  echo "Env overrides: BITCAST_DIR, BITCAST_X_DIR, MASTER_ENV"
}

if [ ! -d "$BITCAST_DIR" ] || [ ! -d "$BITCAST_X_DIR" ]; then
  echo "Expected repos at:"
  echo "  BITCAST_DIR=$BITCAST_DIR"
  echo "  BITCAST_X_DIR=$BITCAST_X_DIR"
  echo "Set env vars to override paths if needed."
fi

if [ ! -f "$MASTER_ENV" ]; then
  echo "Master .env not found at $MASTER_ENV"
  echo "Copy env.example to .env and fill values."
  exit 1
fi

# Export vars from master .env
set -a
source "$MASTER_ENV"
set +a

# Fan out env files to repos
bash "$REPO_ROOT/scripts/sync_env.sh"

# Setup environments in both repos
bash "$BITCAST_DIR/scripts/setup_env.sh"
bash "$BITCAST_X_DIR/scripts/setup_env.sh"

# Start validators (one per codebase)
echo "Starting validator (bitcast)..."
bash "$BITCAST_DIR/scripts/run_validator.sh"

echo "Starting validator (bitcast-x)..."
bash "$BITCAST_X_DIR/scripts/run_validator.sh"

# Show pm2 status
pm2 status | egrep 'bitcast_validator|bitcast_x_validator' || true
