#!/bin/bash
set -euo pipefail

MASTER_ENV=${MASTER_ENV:-"$(cd "$(dirname "$0")/.." && pwd)/.env"}
BITCAST_DIR=${BITCAST_DIR:-/home/ubuntu/bitcast}
BITCAST_X_DIR=${BITCAST_X_DIR:-/home/ubuntu/bitcast-x}
MODE=${MODE:-symlink} # or "copy"

require() { [ -f "$1" ] || { echo "Missing file: $1"; exit 1; }; }
require "$MASTER_ENV"

# target locations expected by the repos
B_VALIDATOR_ENV="$BITCAST_DIR/bitcast/validator/.env"
BX_VALIDATOR_ENV="$BITCAST_X_DIR/bitcast/validator/.env"

mkdir -p "$(dirname "$B_VALIDATOR_ENV")" \
         "$(dirname "$BX_VALIDATOR_ENV")"

link_or_copy() {
  local src="$1" dst="$2"
  if [ "$MODE" = "copy" ]; then
    cp "$src" "$dst"
  else
    ln -sf "$src" "$dst"
  fi
  echo "Provisioned env -> $dst"
}

link_or_copy "$MASTER_ENV" "$B_VALIDATOR_ENV"
link_or_copy "$MASTER_ENV" "$BX_VALIDATOR_ENV"
