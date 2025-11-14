#!/bin/bash
# Lightweight venv setup script that skips system package installation
# Used by deploy.sh to avoid repeated apt operations

set -euo pipefail

REPO_DIR="$1"
VENV_PATH="$2"
REPO_NAME="$3"

echo "Setting up Python environment for $REPO_NAME..."

# Create virtual environment if it doesn't exist
if [ ! -d "$VENV_PATH" ]; then
    echo "  Creating virtual environment at $VENV_PATH"
    python3 -m venv "$VENV_PATH"
else
    echo "  ✓ Virtual environment already exists"
fi

# Change to repo directory
cd "$REPO_DIR"

# Install/upgrade dependencies using venv's pip directly
echo "  Installing Python packages..."
"$VENV_PATH/bin/pip" install --upgrade pip -q
"$VENV_PATH/bin/pip" install -r requirements.txt -q
"$VENV_PATH/bin/pip" install -e . -q

echo "  ✓ Python environment ready for $REPO_NAME"

