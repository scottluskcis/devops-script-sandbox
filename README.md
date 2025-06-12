# Script Sandbox

## Overview

Various scripts used for a variety of things

## Scripts

### GitHub App Token Generator

The [generate-app-token.sh](scripts/generate-app-token.sh) script generates GitHub App tokens for API authentication.

**Usage:**

```bash
./scripts/generate-app-token.sh
```

Outputs a GitHub App token and its expiration time.

### Repository Mirror

The [mirror-repository.sh](scripts/mirror-repository.sh) script clones a source repository and mirrors it to a target repository using GitHub App authentication.

**Usage:**

```bash
./scripts/mirror-repository.sh
```

Mirrors the source repository to the target and optionally creates a pull request if configured.

#### Setup

1. **Create environment file**: Copy the example environment file and configure it with your GitHub App credentials:

   ```bash
   cp .env.example .env
   ```

2. **Configure `.env` file**: Edit the `.env` file with your actual values:

   ```bash
   APP_ID=your_actual_app_id
   CLIENT_ID=your_actual_client_id
   INSTALLATION_ID=your_actual_installation_id
   PEM_FILE=keys/your-private-key.pem
   TOKEN_API_DOMAIN=api.github.com
   SOURCE_REPO_URL=https://github.com/source-org/source-repo.git
   TARGET_ORG=your-target-org
   REPO_NAME=your-target-repo
   TARGET_DOMAIN=github.com
   # Optionally set CREATE_PR=true to create a PR instead of pushing directly
   # CREATE_PR=true
   ```

   **Required values:**

   - `APP_ID`: Your GitHub App's ID
   - `CLIENT_ID`: Your GitHub App's Client ID
   - `INSTALLATION_ID`: The installation ID for your GitHub App
   - `PEM_FILE`: Path to your GitHub App's private key file (relative to project root)
   - `TOKEN_API_DOMAIN`: GitHub API domain (usually `api.github.com`)
   - `SOURCE_REPO_URL`: The HTTPS URL of the source repository to mirror
   - `TARGET_ORG`: The target GitHub organization
   - `REPO_NAME`: The name of the target repository
   - `TARGET_DOMAIN`: The GitHub domain (usually `github.com`)
   - `CREATE_PR`: (Optional) Set to `true` to create a pull request instead of pushing directly to `main`

3. **Place your private key**: Put your GitHub App's private key file in the `keys/` directory
