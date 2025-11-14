#!/bin/bash
set -euo pipefail

# Get the absolute path to the bitcast-deploy root
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# Simplified consolidated structure
REPOS_DIR="$REPO_ROOT/repos"
BITCAST_DIR="$REPOS_DIR/bitcast"
BITCAST_X_DIR="$REPOS_DIR/bitcast-x"
BITCAST_VENV="$REPOS_DIR/venv_bitcast"
BITCAST_X_VENV="$REPOS_DIR/venv_bitcast_x"
MASTER_ENV="$REPO_ROOT/.env"

# Allow environment variable overrides for advanced users
BITCAST_DIR=${BITCAST_DIR:-$BITCAST_DIR}
BITCAST_X_DIR=${BITCAST_X_DIR:-$BITCAST_X_DIR}

usage() {
  echo "Usage: $0"
  echo "Consolidated deployment under: $REPO_ROOT"
  echo "  - All repos and venvs: $REPOS_DIR"
}

echo "🚀 Bitcast Multi-Validator Deployment"
echo "======================================"
echo ""

#######################
# 1. Check master .env
#######################
if [ ! -f "$MASTER_ENV" ]; then
  echo "❌ Master .env not found at $MASTER_ENV"
  echo "   Copy env.example to .env and fill in your configuration."
  exit 1
fi

echo "✓ Master .env found"

#######################
# 2. Create directory structure
#######################
echo ""
echo "📁 Setting up directory structure..."
mkdir -p "$REPOS_DIR"

echo "✓ Directory structure created"

#######################
# 3. Clone repositories
#######################
echo ""
echo "📦 Checking repositories..."

if [ ! -d "$BITCAST_DIR" ]; then
  echo "   Cloning bitcast (YouTube validator)..."
  git clone https://github.com/bitcast-network/bitcast.git "$BITCAST_DIR"
else
  echo "   ✓ bitcast repository exists"
fi

if [ ! -d "$BITCAST_X_DIR" ]; then
  echo "   Cloning bitcast-x (X validator)..."
  git clone https://github.com/bitcast-network/bitcast-x.git "$BITCAST_X_DIR"
else
  echo "   ✓ bitcast-x repository exists"
fi

echo "✓ Repositories ready"

#######################
# 4. Sync .env files
#######################
echo ""
echo "🔗 Syncing environment configuration..."
bash "$REPO_ROOT/scripts/sync_env.sh"

#######################
# 5. Setup environments
#######################
echo ""
echo "🐍 Setting up Python virtual environments..."

# Export vars from master .env
set -a
source "$MASTER_ENV"
set +a

# Setup bitcast validator
echo "   Setting up bitcast validator environment..."
export VENV_PATH="$BITCAST_VENV"
bash "$BITCAST_DIR/scripts/setup_env.sh"

# Setup bitcast-x validator
echo "   Setting up bitcast-x validator environment..."
export VENV_PATH="$BITCAST_X_VENV"
bash "$BITCAST_X_DIR/scripts/setup_env.sh"

echo "✓ Virtual environments configured"

#######################
# 6. Start validators
#######################
echo ""
echo "🚀 Starting validators..."

# Set venv paths for run scripts
export VENV_PATH="$BITCAST_VENV"
bash "$BITCAST_DIR/scripts/run_validator.sh"

export VENV_PATH="$BITCAST_X_VENV"
bash "$BITCAST_X_DIR/scripts/run_validator.sh"

echo ""
echo "✓ Validators started"

#######################
# 7. Show status
#######################
echo ""
echo "📊 Validator Status:"
echo "==================="
pm2 status | egrep 'bitcast_validator|bitcast_x_validator' || echo "No validators found in PM2"

echo ""
echo "✅ Deployment complete!"
echo ""
echo "Directory Structure:"
echo "  Root:       $REPO_ROOT"
echo "  Repos/Venvs: $REPOS_DIR"
echo ""
echo "Management Commands:"
echo "  Status:  pm2 status"
echo "  Logs:    pm2 logs bitcast_validator"
echo "  Logs:    pm2 logs bitcast_x_validator"
echo "  Restart: pm2 restart all"
echo "  Stop:    bash $REPO_ROOT/scripts/stop.sh"
