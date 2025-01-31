#!/bin/bash

# Check if exactly three arguments are provided
if [[ $# -ne 3 ]]; then
    echo "Usage: $0 <source_directory> <backup_directory> <file_extension>"
    exit 1
fi

# Assign arguments to meaningful variable names
src_dir="$1"
backup_dir="$2"
file_ext="$3"

# Verify that the source directory exists
if [[ ! -d "$src_dir" ]]; then
    echo "Error: Source directory '$src_dir' does not exist!"
    exit 1
fi

# Create the backup directory if it doesn't exist
if [[ ! -d "$backup_dir" ]]; then
    mkdir -p "$backup_dir" || { echo "Error: Unable to create backup directory '$backup_dir'!"; exit 1; }
fi

# Find all files with the specified extension in the source directory
shopt -s nullglob  # Enable nullglob to handle no matches gracefully
files=("$src_dir"/*"$file_ext")

# Check if any matching files were found
if [[ ${#files[@]} -eq 0 ]]; then
    echo "No files found with extension '$file_ext' in '$src_dir'."
    exit 0
fi

# Initialize counters for backup statistics
backup_count=0
total_size=0

# Start the backup process
for file in "${files[@]}"; do
    base_name=$(basename "$file")
    dest_file="$backup_dir/$base_name"

    # Get the size of the current file
    file_size=$(stat -c%s "$file")

    # Check if the destination file exists and compare timestamps
    if [[ -f "$dest_file" ]]; then
        if [[ "$file" -nt "$dest_file" ]]; then
            cp "$file" "$dest_file"
            echo "Updated: $base_name ($file_size bytes)"
        else
            echo "Skipped: $base_name (Already up-to-date)"
            continue
        fi
    else
        cp "$file" "$dest_file"
        echo "Copied: $base_name ($file_size bytes)"
    fi

    # Update backup statistics
    ((backup_count++))
    total_size=$((total_size + file_size))
done

# Generate a backup report
report_file="$backup_dir/backup_report.log"
{
    echo "Backup Summary"
    echo "--------------"
    echo "Total files processed: $backup_count"
    echo "Total size of files backed up: $total_size bytes"
    echo "Backup Directory: $backup_dir"
} >> "$report_file"

echo "Backup completed! Report saved in '$report_file'."
