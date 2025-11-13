#!/bin/bash
set -euo pipefail

NAMES=(
  bitcast_validator
  bitcast_x_validator
)

for name in "${NAMES[@]}"; do
  if pm2 list | grep -q "$name"; then
    echo "Stopping $name..."
    pm2 stop "$name" || true
  fi
done
