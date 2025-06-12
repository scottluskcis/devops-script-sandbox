#!/usr/bin/env bash

set -o pipefail

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source the utility functions
source "$SCRIPT_DIR/load-env.sh"
source "$SCRIPT_DIR/validate-env.sh"

# Load environment variables
load_env "$SCRIPT_DIR"

# Validate required environment variables
validate_required_vars "CLIENT_ID" "PEM_FILE" "INSTALLATION_ID" "TOKEN_API"

# call the generate-jwt.sh and pass in CLIENT_ID as first arg and PEM_FILE as second arg
GITHUB_JWT=$("$SCRIPT_DIR/generate-jwt.sh" "$CLIENT_ID" "$PEM_FILE")

# get the url for the app token
APP_TOKEN_URL="https://${TOKEN_API}/app/installations/${INSTALLATION_ID}/access_tokens"

export APP_TOKEN=$( curl -s -X POST -H "Authorization: Bearer ${GITHUB_JWT}" -H "Accept: application/vnd.github.v3+json" ${APP_TOKEN_URL} | jq -r .token )

# Check if the APP_TOKEN was successfully retrieved
if [[ -z "$APP_TOKEN" ]]; then
    echo "Error: Failed to retrieve the app token. Please check your configuration." >&2
    exit 1
else
    echo -e "\n"
    echo "App token successfully generated and stored in APP_TOKEN environment variable."
    echo "You can now use this token for further API requests."
    echo "Note: The token is valid for 1 hour. You may need to regenerate it periodically."
    echo "To regenerate, run this script again."

    echo -e "\n-------------------------------------------------"
    echo "TOKEN: $APP_TOKEN"
    echo -e "\n"
    echo "Generated at: $(date '+%Y-%m-%d %H:%M:%S %Z')"
    echo "Expires at:   $(date -v+1H '+%Y-%m-%d %H:%M:%S %Z')"
    echo -e "-------------------------------------------------\n"
    
fi
