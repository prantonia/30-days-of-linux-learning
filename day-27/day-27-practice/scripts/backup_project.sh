#!/bin/bash
set -euo pipefail

PROJECT_DIR="$HOME/projects/30-days-of-linux-learning"
BACKUP_DIR="$HOME/backups"
DATE=$(date +%F)
BACKUP_FILE="$BACKUP_DIR/linux-learning-$DATE.tar.gz"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

check_directory() {
    if [ ! -d "$1" ]; then
        log "ERROR: Directory does not exist: $1"
        exit 1
    fi
}

main() {
    log "Starting backup..."

    check_directory "$PROJECT_DIR"
    mkdir -p "$BACKUP_DIR"

    tar -czf "$BACKUP_FILE" "$PROJECT_DIR"

    log "Backup completed: $BACKUP_FILE"
}

main "$@"
