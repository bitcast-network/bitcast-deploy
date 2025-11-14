#!/bin/bash
set -euo pipefail

echo "🔧 Bitcast System Dependencies Setup"
echo "====================================="
echo ""

# Check if we need to run this
if command -v pm2 &> /dev/null && command -v python3 &> /dev/null; then
    echo "✓ System dependencies already installed"
    echo ""
    echo "If you need to reinstall, run:"
    echo "  sudo apt update && sudo apt install -y python3-pip python3-venv npm"
    echo "  sudo npm install -g pm2@latest"
    exit 0
fi

echo "📦 Installing system dependencies..."
echo ""

# Update system
echo "Updating package lists..."
sudo apt update -y

# Install core dependencies
echo "Installing Python and npm..."
sudo apt install -y \
    python3-pip \
    python3-venv \
    npm

# Install PM2 if not already installed
if ! command -v pm2 &> /dev/null; then
    echo "Installing PM2 process manager..."
    sudo npm install -g pm2@latest
else
    echo "✓ PM2 already installed"
fi

echo ""
echo "✅ System dependencies installed successfully!"
echo ""
echo "You can now run: bash scripts/deploy.sh"

