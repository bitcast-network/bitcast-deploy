<p align="center">
  <a href="https://www.bitcast.network/">
    <img src="assets/lockup_gradient.svg" alt="Bitcast Logo" width="800" />
  </a>
</p>

# Bitcast Deploy — Minimal Validator Launcher

Bitcast is a decentralized protocol aligning brands, creators, and validators across two production subnets. This repository provides the fastest way to launch validators with production defaults.

- Bitcast (YouTube): briefs, video analytics validation, and on‑chain rewards on subnet 93
- Bitcast X (X.com): social mining and validation based on influence and engagement

---

This repository deploys validators only (one for Bitcast video and one for Bitcast X). If you want to mine, use the specific repo for YouTube or X.

## Highlights
- **One‑command deploy**: Start both validators in a single step
- **Process management**: pm2‑managed services with restart, uptime, and logs
- **Hermetic environments**: Per‑repo Python venvs, idempotent setup scripts
- **Single‑source configuration**: One `.env` fanned out to both validators
- **Secure by default**: X validator can run in Weight‑Copy mode (no API keys). Full validation uses API keys via env files only.
- **Observability**: `pm2 status`, `pm2 logs <name>` for quick diagnosis

## Quickstart
```bash
# 1) Configure env
cp env.example .env
# edit .env and fill values (wallet, optional API keys)

# 2) Deploy both validators
bash scripts/deploy.sh

# 3) Check status / logs
bash scripts/status.sh
pm2 logs bitcast_validator
pm2 logs bitcast_x_validator

# 4) Stop both validators
bash scripts/stop.sh
```

## Environment
Single master `.env` is used for both validators. It is symlinked into each repo at the location they expect (`bitcast/validator/.env`).

Minimum required variables:
- `WALLET_NAME`: Bittensor wallet name (coldkey)
- `HOTKEY_NAME`: Validator hotkey
- `NETUID` (default `93`)
- `SUBTENSOR_NETWORK` (default `finney`)
- `SUBTENSOR_CHAIN_ENDPOINT` (default `wss://entrypoint-finney.opentensor.ai:443`)

Bitcast (video) validator also requires (full validation):
- `RAPID_API_KEY`
- `CHUTES_API_KEY`
- `WANDB_API_KEY`

Bitcast X validator can run in Weight‑Copy mode without API keys, but will warn if missing; the master `.env` supports setting them if you run full validation.

## What this does
- Syncs your master `.env` into both repos
- Runs each repo’s `scripts/setup_env.sh` (creates venvs, installs deps, pm2 if needed)
- Starts exactly two pm2 processes:
  - `bitcast_validator` (video)
  - `bitcast_x_validator` (X.com)

## References
- Bitcast (video) README: see repo at `/home/ubuntu/bitcast/README.md`
- Bitcast X README: see repo at `/home/ubuntu/bitcast-x/README.md`
