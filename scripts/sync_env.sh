#!/bin/bash
set -euo pipefail

# Get the absolute path to the bitcast-deploy root
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# New consolidated directory structure
REPOS_DIR="$REPO_ROOT/repos"
MASTER_ENV="$REPO_ROOT/.env"

BITCAST_DIR="$REPOS_DIR/bitcast"
BITCAST_X_DIR="$REPOS_DIR/bitcast-x"

# Sync mode: symlink (default) or copy
MODE=${MODE:-symlink}

# Verify master .env exists
if [ ! -f "$MASTER_ENV" ]; then
  echo "❌ Master .env not found at $MASTER_ENV"
  exit 1
fi

# Target .env locations in validator repos
B_VALIDATOR_ENV="$BITCAST_DIR/bitcast/validator/.env"
BX_VALIDATOR_ENV="$BITCAST_X_DIR/bitcast/validator/.env"

# Create directories if they don't exist
mkdir -p "$(dirname "$B_VALIDATOR_ENV")"
mkdir -p "$(dirname "$BX_VALIDATOR_ENV")"

# Function to create symlink or copy
link_or_copy() {
  local src="$1"
  local dst="$2"
  
  # Remove existing file/symlink
  [ -e "$dst" ] && rm -f "$dst"
  
  if [ "$MODE" = "copy" ]; then
    cp "$src" "$dst"
    echo "   ✓ Copied: $dst"
  else
    ln -sf "$src" "$dst"
    echo "   ✓ Symlinked: $dst"
  fi
}

# Sync .env to both validators
link_or_copy "$MASTER_ENV" "$B_VALIDATOR_ENV"
link_or_copy "$MASTER_ENV" "$BX_VALIDATOR_ENV"

echo "✓ Environment configuration synced"
