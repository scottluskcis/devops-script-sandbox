#!/usr/bin/env bash

# Function to find and load .env file
load_env() {
    local script_dir="$1"
    local env_file
    
    # If no script directory provided, try to determine it
    if [[ -z "$script_dir" ]]; then
        script_dir="$(cd "$(dirname "${BASH_SOURCE[1]}")" && pwd)"
    fi
    
    # Check for .env in script directory and parent directory
    for env_file in "$script_dir/.env" "$script_dir/../.env"; do
        if [[ -f "$env_file" ]]; then
            echo "Loading environment from: $env_file" >&2
            set -o allexport
            source "$env_file"
            set +o allexport
            return 0
        fi
    done
    
    echo "Warning: No .env file found" >&2
    return 1
}
