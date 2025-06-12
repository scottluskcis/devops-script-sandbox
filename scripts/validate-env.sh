#!/usr/bin/env bash

# Function to validate required environment variables
validate_required_vars() {
    local missing_vars=()
    
    for var in "$@"; do
        if [[ -z "${!var}" ]]; then
            missing_vars+=("$var")
        fi
    done
    
    if [[ ${#missing_vars[@]} -gt 0 ]]; then
        echo "Error: The following required environment variables are not set:" >&2
        for var in "${missing_vars[@]}"; do
            echo "  - $var" >&2
        done
        echo "Please set them in the .env file or export them as environment variables." >&2
        return 1
    fi
    
    return 0
}

# Function to validate file exists
validate_file_exists() {
    local file_path="$1"
    local var_name="$2"
    
    if [[ ! -f "$file_path" ]]; then
        echo "Error: File not found at $file_path (from $var_name)" >&2
        return 1
    fi
    
    return 0
}
