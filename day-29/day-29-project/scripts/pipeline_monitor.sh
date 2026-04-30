#!/bin/bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"

INCOMING_DIR="$BASE_DIR/incoming"
PROCESSED_DIR="$BASE_DIR/processed"
QUARANTINE_DIR="$BASE_DIR/quarantine"
LOG_FILE="$BASE_DIR/logs/pipeline_monitor.log"

mkdir -p "$INCOMING_DIR" "$PROCESSED_DIR" "$QUARANTINE_DIR" "$BASE_DIR/logs"

log_event() {
    local status="$1"
    local filename="$2"
    local size="$3"
    local rows="$4"
    local message="$5"

    echo "$(date '+%Y-%m-%d %H:%M:%S')|$status|$filename|${size}|${rows}|$message" >> "$LOG_FILE"
}

validate_file() {
    local file="$1"
    local filename
    filename="$(basename "$file")"

    if [ ! -r "$file" ]; then
        log_event "REJECTED" "$filename" "0" "0" "File is not readable"
        mv "$file" "$QUARANTINE_DIR/"
        return
    fi

    if [ ! -s "$file" ]; then
        log_event "REJECTED" "$filename" "0" "0" "File is empty"
        mv "$file" "$QUARANTINE_DIR/"
        return
    fi

    case "$filename" in
        *.csv|*.json)
            ;;
        *)
            local size
            size=$(stat -c%s "$file")
            log_event "REJECTED" "$filename" "$size" "0" "Invalid file extension"
            mv "$file" "$QUARANTINE_DIR/"
            return
            ;;
    esac

    local size
    local rows

    size=$(stat -c%s "$file")
    rows=$(wc -l < "$file")

    log_event "ACCEPTED" "$filename" "$size" "$rows" "File passed validation"

    mv "$file" "$PROCESSED_DIR/"
}

main() {
    shopt -s nullglob

    for file in "$INCOMING_DIR"/*; do
        [ -f "$file" ] || continue
        validate_file "$file"
    done
}

main "$@"
