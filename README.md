<p align="center">
  <a href="https://www.bitcast.network/">
    <img src="assets/lockup_gradient.svg" alt="Bitcast Logo" width="800" />
  </a>
</p>

# Bitcast Deploy — Multi-Validator Setup

Bitcast is a decentralized protocol connecting brands with creators through on-chain incentives across multiple content platforms.

---

## ⚙️ The Bitcast Ecosystem

Bitcast operates the following bittensor subnet mechanisms on netuid-93:

- **[Bitcast Youtube](https://github.com/bitcast-network/bitcast)**: YouTube content mining with analytics-based validation and rewards  
- **[Bitcast X](https://github.com/bitcast-network/bitcast-x)**: X.com social mining with influence-based scoring and engagement tracking

---

## 🚀 Getting Started

### For Miners

To mine, choose your platform and follow the setup instructions in its repository:

- **YouTube**: [github.com/bitcast-network/bitcast](https://github.com/bitcast-network/bitcast)
- **X (Twitter)**: [github.com/bitcast-network/bitcast-x](https://github.com/bitcast-network/bitcast-x)

### For Validators

This repository provides a streamlined setup to run validators for **both** Bitcast subnets simultaneously from a single configuration.

**Key Features:**
- **One-command deployment**: Start both validators in a single step
- **Unified configuration**: Single `.env` file for both validators
- **Process management**: PM2-managed services with automatic restart and logging
- **Isolated environments**: Separate Python virtual environments per subnet

---

## 💻 System Requirements

- **Operating System**: Linux
- **CPU**: 1+ cores
- **RAM**: 2+ GB

---

## 🔧 Installation & Setup

### 1. Clone this Repository

```bash
cd ~
git clone https://github.com/bitcast-network/bitcast-deploy.git
cd bitcast-deploy
```

> **Note**: The deployment script will automatically clone the `bitcast` and `bitcast-x` repositories into a consolidated directory structure.

### 2. Install System Dependencies

Run the system setup script once (requires sudo):

```bash
bash scripts/system_setup.sh
```

This installs Python, npm, and PM2. You only need to run this once per server.

### 3. Configure Environment

Create your configuration file:

```bash
cp env.example .env
```

Edit `.env` and set your validator configuration:

**Required:**
- `WALLET_NAME`: Your Bittensor wallet name (coldkey)
- `HOTKEY_NAME`: Your validator hotkey name
- `RAPID_API_KEY`: Your RapidAPI key
- `CHUTES_API_KEY`: Your Chutes.ai API key
- `WANDB_API_KEY`: Your Weights & Biases API key

**Ports:**
- `BITCAST_PORT`: YouTube validator port (default: 8092)
- `BITCAST_X_PORT`: X validator port (default: 8093)
  
> **Note**: Each validator requires a unique port. Make sure these ports are not in use by other services.

**Optional:**
- `DISABLE_AUTO_UPDATE`: Set to `true` to disable automatic updates (default: true)

### 4. Deploy Validators

Run the deployment script:

```bash
bash scripts/deploy.sh
```

This script will:
- Check that system dependencies are installed
- Create a consolidated directory structure under `repos/`
- Automatically clone the `bitcast` and `bitcast-x` repositories (if not present)
- Create isolated Python virtual environments for each validator
- Install Python dependencies for both validators
- Configure PM2 process management
- Synchronize your `.env` configuration to both validators
- Start both validator services

> **Note**: The deploy script no longer runs `apt install` commands, preventing lock conflicts. System dependencies are installed once via `system_setup.sh`.

### 5. Register on Bittensor Network (If Not Already Registered)

If you haven't already registered a UID for your validator:

```bash
# Register Subnet 93
btcli subnet register \
  --netuid 93 \
  --wallet.name <WALLET_NAME> \
  --wallet.hotkey <HOTKEY_NAME>
```

---

## 📊 Managing Your Validators

Both validators run as PM2 processes:
- `bitcast_validator` - Bitcast YouTube validator
- `bitcast_x_validator` - Bitcast X validator

Use standard PM2 commands to manage them: `pm2 status`, `pm2 logs`, `pm2 restart`, etc.

---

## 📁 Project Structure

After deployment, your directory structure will look like this:

```
bitcast-deploy/
├── .env                   # Master configuration (symlinked to validators)
├── .gitignore            # Excludes repos and .env from git
├── env.example           # Example environment configuration
├── README.md
│
├── scripts/
│   ├── deploy.sh         # Main deployment script
│   ├── sync_env.sh       # Syncs .env to validators
│   ├── status.sh         # Check validator status
│   └── stop.sh           # Stop all validators
│
└── repos/                # All repositories and virtual environments
    ├── bitcast/          # YouTube validator (auto-cloned)
    ├── bitcast-x/        # X validator (auto-cloned)
    ├── venv_bitcast/     # YouTube validator venv
    └── venv_bitcast_x/   # X validator venv
```

**Key Features:**
- **Consolidated Structure**: Everything under one parent directory
- **Single Configuration**: Master `.env` file symlinked to both validators
- **Isolated Environments**: Separate venvs prevent dependency conflicts
- **Auto-update Compatible**: Repos maintain their git history for auto-updates
- **Simple Layout**: Repos and their venvs live together as siblings

---

## ℹ️ General Notes

- **Auto-updates**: Both validators support automatic updates - git operations work normally in nested repos
- **Configuration sync**: The master `.env` file is automatically symlinked to both validator directories
- **Process isolation**: Each validator runs as a separate PM2 process for reliability
- **Data persistence**: Cache and logs are managed by the validators within their repo directories

---

## 🔄 Migrating from Old Structure

If you previously had validators installed at `~/bitcast/` and `~/bitcast-x/`:

**Option 1: Fresh Install (Recommended)**
```bash
# Stop old validators
pm2 stop all
pm2 delete all

# Backup your .env if needed
cp ~/bitcast/bitcast/validator/.env ~/bitcast-deploy/.env

# Remove old directories
rm -rf ~/bitcast ~/bitcast-x ~/venv_bitcast ~/venv_bitcast_x

# Run new deployment
cd ~/bitcast-deploy
bash scripts/deploy.sh
```

**Option 2: Move Existing Repos (Preserves existing data/venvs)**
```bash
# Stop validators
pm2 stop all
pm2 delete all

# Create new structure
mkdir -p ~/bitcast-deploy/repos

# Move existing repos and venvs
mv ~/bitcast ~/bitcast-deploy/repos/
mv ~/bitcast-x ~/bitcast-deploy/repos/
mv ~/venv_bitcast ~/bitcast-deploy/repos/
mv ~/venv_bitcast_x ~/bitcast-deploy/repos/

# Copy your .env to the master location
cp ~/bitcast-deploy/repos/bitcast/bitcast/validator/.env ~/bitcast-deploy/.env

# Run deployment (will detect existing repos and venvs)
cd ~/bitcast-deploy
bash scripts/deploy.sh
```

---

## 🤝 Contact & Support

For assistance or questions, join our Discord support channel:

[Bitcast Support on Bittensor Discord](https://discord.com/channels/799672011265015819/1362489640841380045)

---

## 🔗 Links

- **Website**: [bitcast.network](https://www.bitcast.network/)
- **Token**: [Bitcast on CoinGecko](https://www.coingecko.com/en/coins/bitcast)
