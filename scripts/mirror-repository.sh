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
validate_required_vars "SOURCE_REPO_URL" "TARGET_ORG" "REPO_NAME" "TARGET_DOMAIN"

# Configuration - set this to true to create PR, false to push directly
CREATE_PR=${CREATE_PR:-false}  # Default to false, can be overridden by environment variable

set -e

# Generate the target token using our existing script
echo "Generating GitHub App token..."
TARGET_TOKEN=$("$SCRIPT_DIR/generate-app-token.sh" | grep "TOKEN:" | cut -d' ' -f2)

# Check if the TARGET_TOKEN was successfully retrieved
if [[ -z "$TARGET_TOKEN" ]]; then
    echo "Error: Failed to retrieve the target token. Please check your GitHub App configuration." >&2
    exit 1
fi

echo "Target token successfully generated."

# cleanup if exists
rm -rf temp-repo

# Clone source repository
echo "Cloning source repository: $SOURCE_REPO_URL"
git clone --bare "$SOURCE_REPO_URL" temp-repo
cd temp-repo

# Configure git
git config user.name "migration-actions[bot]"
git config user.email "migration-actions[bot]@users.noreply.github.com"

# Add target remote
echo "Adding target remote: https://$TARGET_DOMAIN/$TARGET_ORG/$REPO_NAME.git"
git remote add target "https://x-access-token:$TARGET_TOKEN@$TARGET_DOMAIN/$TARGET_ORG/$REPO_NAME.git"

if [ "$CREATE_PR" = true ]; then
    # Create a sync branch
    SYNC_BRANCH="sync-$(date +%Y%m%d%H%M%S)" 

    # Only push main to mirror-sync branch on target
    echo "Creating sync branch: $SYNC_BRANCH"
    git push target refs/heads/main:refs/heads/$SYNC_BRANCH --force
    git push target --tags --force

    # Create a PR from mirror-sync to main
    echo "Creating pull request from $SYNC_BRANCH to main on $TARGET_ORG/$REPO_NAME"
    curl -X POST "https://$TARGET_DOMAIN/api/v3/repos/$TARGET_ORG/$REPO_NAME/pulls" \
    -H "Authorization: Bearer $TARGET_TOKEN" \
    -H "Accept: application/vnd.github+json" \
    -H "Content-Type: application/json" \
    -d '{
        "title": "Mirror Sync: '"$(date +%Y-%m-%d)"'",
        "head": "'"$SYNC_BRANCH"'",
        "base": "main",
        "body": "Automated synchronization of main branch."
    }'
else
    # Push directly to main branch (GitHub App should be on bypass list)
    echo "Pushing directly to main branch on $TARGET_ORG/$REPO_NAME"
    git push target refs/heads/main:refs/heads/main --force
    
    # Push tags
    echo "Pushing tags"
    git push target --tags --force
fi 

# Cleanup
cd ..
rm -rf temp-repo

echo "Repository mirroring completed successfully!"
