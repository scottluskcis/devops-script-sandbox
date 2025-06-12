# Script Sandbox

## Overview

Various scripts used for a variety of things

## Scripts

### GitHub App Token Generator

The [generate-app-token.sh](scripts/generate-app-token.sh) script generates GitHub App tokens for API authentication.

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
   ```

   **Required values:**

   - `APP_ID`: Your GitHub App's ID
   - `CLIENT_ID`: Your GitHub App's Client ID
   - `INSTALLATION_ID`: The installation ID for your GitHub App
   - `PEM_FILE`: Path to your GitHub App's private key file (relative to project root)
   - `TOKEN_API_DOMAIN`: GitHub API domain (usually `api.github.com`)

3. **Place your private key**: Put your GitHub App's private key file in the `keys/` directory

#### Usage

Run the script to generate a GitHub App token:

```bash
./scripts/generate-app-token.sh
```

The script will:

- Load configuration from your `.env` file
- Generate a JWT token using your private key
- Exchange the JWT for an App token
- Display the token with expiration information

**Note**: Generated tokens are valid for 1 hour. You'll need to run the script again to generate a new token when it expires.

#### Output

Upon successful execution, you'll see:

- Confirmation message
- Token generation and expiration timestamps
- The actual token value
- The token is also exported as the `APP_TOKEN` environment variable for use in the current session
