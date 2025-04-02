#!/usr/bin/env bash

logs_path="$HOME/Logs"

# Ensure the Logs folder exists
mkdir -p "$logs_path"

# Redirect all output (stdout and stderr) to a timestamped log file
logfile="$logs_path/backup-$(date +'%F-%H-%M').log"
exec >> "$logfile" 2>&1

# Define directories to back up
source_dir=(
    "$HOME/Documents"
    "$HOME/Images"
    "$HOME/Music"
    "$HOME/Videos"
    "$HOME/Project"
    "$HOME/Executables"
    "$HOME/Logs"
)

# Define backup destination and archive name
backup_path="$HOME/Backups"
archive_name="$(date +'%F-%H-%M').tar.gz"

# Ensure the backup folder exists
mkdir -p "$backup_path"

# Filter only existing directories before creating the archive
# This prevents tar from failing if a directory does not exist
valid_dirs=()

for dir in "${source_dir[@]}"; do
    if [[ -d "$dir" ]]; then
        valid_dirs+=("$dir")
    else
        echo "$(date +'%F %T') Skipped missing directory: $dir"
    fi
done

# Create a compressed archive of the selected directories
tar -czf "$backup_path/$archive_name" --exclude="$PWD" "${valid_dirs[@]}"

# Log the backup action
echo "$(date +'%F %T') Created archive: $archive_name"

# Remove backup archives older than 7 days
find "$backup_path" -name "*.tar.gz" -mtime +7 -exec rm {} \;

# Automatically delete old sorter logs (older than 3 days)
find "$logs_path" -name "backup-*.log" -mtime +3 -exec rm {} \;