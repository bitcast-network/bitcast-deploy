#!/bin/bash
set -euo pipefail
pm2 status | egrep 'bitcast_validator|bitcast_x_validator' || true
