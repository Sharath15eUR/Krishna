#!/bin/bash

# Global variables
SCRIPT_NAME=$(basename "$0")
ERROR_LOG="errors.log"

# Help menu using here document
display_help() {
    cat <<EOF
Usage: $SCRIPT_NAME [OPTIONS]

Options:
  -d, --directory <dir>    Directory to search recursively
  -f, --file <file>        Specific file to search
  -k, --keyword <keyword>  Keyword to search for (required)
  --help                   Show this help menu

Examples:
  $SCRIPT_NAME -d logs -k error
  $SCRIPT_NAME -f script.sh -k TODO
EOF
}

# Error logging function
log_error() {
    local message="$1"
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $message" >> "$ERROR_LOG"
    echo "Error: $message" >&2
}

# Recursive search function
search_directory() {
    local dir="$1"
    local keyword="$2"
    
    # Check if directory exists
    [[ ! -d "$dir" ]] && log_error "Directory not found: $dir" && return 1

    # Process each item in directory
    for item in "$dir"/*; do
        if [[ -f "$item" ]]; then
            # Check file for keyword
            if grep -q "$keyword" "$item"; then
                echo "Found in file: $item"
            fi
        elif [[ -d "$item" ]]; then
            # Recursive call for subdirectories
            search_directory "$item" "$keyword"
        fi
    done
}

# Validate inputs
validate_inputs() {
    # Check keyword exists and is valid
    [[ -z "$keyword" ]] && log_error "Keyword is required" && return 1
    [[ "$keyword" =~ ^[[:space:]]*$ ]] && log_error "Invalid keyword" && return 1

    # Check either directory or file is specified
    if [[ -n "$directory" && -n "$file" ]]; then
        log_error "Cannot specify both directory and file"
        return 1
    fi

    # Validate file exists if specified
    if [[ -n "$file" && ! -f "$file" ]]; then
        log_error "File not found: $file"
        return 1
    fi

    return 0
}

# Main script execution
main() {
    # Check for --help first
    if [[ "$@" == *"--help"* ]]; then
        display_help
        exit 0
    fi

    # Parse command-line options
    while getopts ":d:f:k:" opt; do
        case $opt in
            d) directory="$OPTARG" ;;
            f) file="$OPTARG" ;;
            k) keyword="$OPTARG" ;;
            \?) log_error "Invalid option: -$OPTARG" ;;
            :) log_error "Option -$OPTARG requires an argument" ;;
        esac
    done

    # Validate inputs
    validate_inputs || exit 1

    # Perform search operation
    if [[ -n "$directory" ]]; then
        search_directory "$directory" "$keyword"
    elif [[ -n "$file" ]]; then
        # Using here string for file search
        if grep -q "$keyword" <<< "$(cat "$file")"; then
            echo "Found in file: $file"
        else
            log_error "Keyword not found in file: $file"
        fi
    fi

    exit $?
}

# Start main function
main "$@"
