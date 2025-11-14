# Migration to Consolidated Structure

## What Changed

The deployment structure has been reorganized from a scattered home directory layout to a consolidated structure under `bitcast-deploy/`.

### Old Structure (Scattered)
```
/home/ubuntu/
├── bitcast/                    # YouTube validator
├── bitcast-x/                  # X validator  
├── bitcast-deploy/             # Deploy scripts only
├── venv_bitcast/               # YouTube venv
└── venv_bitcast_x/             # X venv
```

### New Structure (Consolidated)
```
/home/ubuntu/bitcast-deploy/
├── .env                        # Master config
├── scripts/
└── repos/                      # Everything repo-related
    ├── bitcast/               # YouTube validator
    ├── bitcast-x/             # X validator
    ├── venv_bitcast/          # YouTube venv (sibling to repo)
    └── venv_bitcast_x/        # X venv (sibling to repo)
```

## Benefits

1. **Clean home directory** - Only one directory at root level
2. **Logical organization** - Repos and their venvs live together
3. **Easy backups** - Everything in one place
4. **Portable** - Can move entire deployment by moving one directory
5. **Git-friendly** - `.gitignore` excludes repos and venvs automatically
6. **Auto-update compatible** - Git operations work normally in nested repos

## Key Design Decision

Venvs are siblings to repos (not in a separate directory) because:
- The setup scripts expect `VENV_PATH=$PROJECT_PARENT/venv_*`
- This maintains compatibility with existing repo scripts
- Simpler structure - everything related lives together

## Auto-Updates

Auto-updates will continue to work normally. Each repo maintains its own `.git` directory, so:
- `git pull` operations work as expected
- Auto-update scripts can run without modification
- Git history and branches are preserved

## Files Modified

- `scripts/deploy.sh` - Updated to create consolidated structure under `repos/`
- `scripts/sync_env.sh` - Updated paths to new repo locations
- `.gitignore` - Added to exclude repos/ and .env from git
- `README.md` - Updated documentation with new structure and migration guide

## For Existing Deployments

If you have validators already running, see the "Migrating from Old Structure" section in the README.md file for migration instructions.
