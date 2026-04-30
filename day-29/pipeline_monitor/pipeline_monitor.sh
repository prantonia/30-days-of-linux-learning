#!/bin/bash
# pipeline_monitor.sh
# Linux Data Pipeline File Monitor
# Day 29 - DEC 30 Days of Linux Challenge
#
# What it does:
#   - Watches a directory for incoming data files (CSV, JSON, TXT)
#   - Validates each new file (non-empty, correct extension, readable)
#   - Logs metadata: filename, size, row count, timestamp, status
#   - Generates a daily summary report
#   - Designed to run continuously or via cron


set -euo pipefail


# Configuration
BASE_DIR="/home/prantonia/projects/30-days-of-linux-learning/day-29"
WATCH_DIR="${BASE_DIR}/pipeline_monitor/incoming"
LOG_DIR="${BASE_DIR}/pipeline_monitor/logs"
REPORT_DIR="${BASE_DIR}/pipeline_monitor/reports"
PROCESSED_DIR="${BASE_DIR}/pipeline_monitor/processed"
FAILED_DIR="${BASE_DIR}/pipeline_monitor/failed"


LOG_FILE="${LOG_DIR}/pipeline_$(date +%Y-%m-%d).log"
REPORT_FILE="${REPORT_DIR}/summary_$(date +%Y-%m-%d).txt"
SUPPORTED_EXTENSIONS=("csv" "json" "txt")
POLL_INTERVAL=5  # seconds between directory checks

# Colours for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Colour


# Utility Functions


log() {
    local level="$1"
    local message="$2"
    local timestamp
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "${timestamp} [${level}] ${message}" | tee -a "$LOG_FILE"
}

log_info()    { log "INFO " "$1"; }
log_success() { log "OK   " "$1"; }
log_warn()    { log "WARN " "$1"; }
log_error()   { log "ERROR" "$1"; }

print_banner() {
    echo -e "${CYAN}"
    echo "============================================="
    echo "   Linux Data Pipeline Monitor"
    echo "   DEC 30 Days of Linux - Day 29 Project"
    echo "   $(date '+%Y-%m-%d %H:%M:%S')"
    echo "============================================="
    echo -e "${NC}"
}


# Setup: Create required directories

setup_directories() {
    local dirs=("$WATCH_DIR" "$LOG_DIR" "$REPORT_DIR" "$PROCESSED_DIR" "$FAILED_DIR")
    for dir in "${dirs[@]}"; do
        if [[ ! -d "$dir" ]]; then
            mkdir -p "$dir"
            log_info "Created directory: $dir"
        fi
    done
}


# Validation: Check if a file extension is supported

is_supported_extension() {
    local file="$1"
    local ext="${file##*.}"
    ext="${ext,,}"  # lowercase

    for supported in "${SUPPORTED_EXTENSIONS[@]}"; do
        if [[ "$ext" == "$supported" ]]; then
            return 0
        fi
    done
    return 1
}


# Validation: Full file validation checks
# Returns 0 if valid, 1 if invalid

validate_file() {
    local filepath="$1"
    local filename
    filename=$(basename "$filepath")

    # Check file exists
    if [[ ! -e "$filepath" ]]; then
        log_error "File not found: $filename"
        return 1
    fi

    # Check file is readable
    if [[ ! -r "$filepath" ]]; then
        log_error "File not readable (check permissions): $filename"
        return 1
    fi

    # Check file is not empty
    if [[ ! -s "$filepath" ]]; then
        log_warn "File is empty: $filename"
        return 1
    fi

    # Check supported extension
    if ! is_supported_extension "$filepath"; then
        local ext="${filepath##*.}"
        log_warn "Unsupported file type (.${ext}): $filename"
        return 1
    fi

    return 0
}


# Metadata: Get row count depending on file type

get_row_count() {
    local filepath="$1"
    local ext="${filepath##*.}"
    ext="${ext,,}"
    local count=0

    case "$ext" in
        csv)
            # Subtract 1 for the header row
            count=$(wc -l < "$filepath")
            count=$((count - 1))
            ;;
        json)
            # Count top-level array elements if it's a JSON array
            if grep -q '^\[' "$filepath" 2>/dev/null; then
                count=$(grep -c '^{' "$filepath" || echo "0")
            else
                count=$(wc -l < "$filepath")
            fi
            ;;
        txt)
            count=$(wc -l < "$filepath")
            ;;
        *)
            count=$(wc -l < "$filepath")
            ;;
    esac

    echo "$count"
}


# Metadata: Get human-readable file size

get_file_size() {
    local filepath="$1"
    du -sh "$filepath" | cut -f1
}


# Core: Process a single incoming file

process_file() {
    local filepath="$1"
    local filename
    filename=$(basename "$filepath")
    local timestamp
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")

    echo -e "${BLUE}--------------------------------------------------${NC}"
    log_info "New file detected: $filename"

    # Validate the file
    if ! validate_file "$filepath"; then
        log_error "Validation failed: $filename — moving to failed/"
        mv "$filepath" "${FAILED_DIR}/${filename}"
        # Append to report
        echo "${timestamp} | FAILED     | ${filename} | validation_error" >> "$REPORT_FILE"
        return 1
    fi

    # Gather metadata
    local file_size
    file_size=$(get_file_size "$filepath")

    local row_count
    row_count=$(get_row_count "$filepath")

    local ext="${filename##*.}"
    ext="${ext,,}"

    # Log the metadata
    log_success "File valid: $filename"
    log_info "  Size      : $file_size"
    log_info "  Type      : ${ext^^}"
    log_info "  Row count : $row_count rows"

    # Move to processed
    mv "$filepath" "${PROCESSED_DIR}/${filename}"
    log_info "  Status    : Moved to processed/"

    # Append structured entry to the daily report
    echo "${timestamp} | PROCESSED  | ${filename} | size=${file_size} | rows=${row_count} | type=${ext^^}" >> "$REPORT_FILE"

    echo -e "${GREEN}  Successfully processed: ${filename}${NC}"
    return 0
}


# Report: Generate and display the daily summary

generate_summary() {
    echo ""
    echo -e "${CYAN}=============================================${NC}"
    echo -e "${CYAN}   Daily Pipeline Summary Report${NC}"
    echo -e "${CYAN}   $(date '+%Y-%m-%d')${NC}"
    echo -e "${CYAN}=============================================${NC}"

    if [[ ! -f "$REPORT_FILE" ]] || [[ ! -s "$REPORT_FILE" ]]; then
        echo "  No files processed today yet."
        return
    fi

    local total processed failed
    total=$(wc -l < "$REPORT_FILE")
    processed=$(grep -c "PROCESSED" "$REPORT_FILE" || echo "0")
    failed=$(grep -c "FAILED" "$REPORT_FILE" || echo "0")

    echo ""
    echo "  Total files handled : $total"
    echo -e "  ${GREEN}Successfully processed: $processed${NC}"
    echo -e "  ${RED}Failed validation     : $failed${NC}"
    echo ""
    echo "  --- Processed Files ---"
    grep "PROCESSED" "$REPORT_FILE" | awk -F'|' '{
        printf "  %-30s size=%-6s rows=%s\n", $3, $4, $5
    }' || echo "  None"

    if [[ "$failed" -gt 0 ]]; then
        echo ""
        echo "  --- Failed Files ---"
        grep "FAILED" "$REPORT_FILE" | awk -F'|' '{
            printf "  %-30s reason=%s\n", $3, $4
        }'
    fi

    echo ""
    echo "  Full log  : $LOG_FILE"
    echo "  Report    : $REPORT_FILE"
    echo -e "${CYAN}=============================================${NC}"
}


# Core: Scan the watch directory for new files

scan_directory() {
    local new_files=0

    # Use find to get files only (not directories)
    while IFS= read -r -d '' filepath; do
        process_file "$filepath" && ((new_files++)) || true
    done < <(find "$WATCH_DIR" -maxdepth 1 -type f -print0 2>/dev/null)

    return 0
}


# Cleanup handler — runs on CTRL+C or script exit

cleanup() {
    echo ""
    log_info "Monitor stopped by user."
    generate_summary
    echo -e "${YELLOW}Goodbye! Check your logs at: $LOG_DIR${NC}"
    exit 0
}

trap cleanup INT TERM


# Main entry point

main() {
    print_banner
    setup_directories

    log_info "Monitor started."
    log_info "Watching : $WATCH_DIR"
    log_info "Log file : $LOG_FILE"
    log_info "Polling every ${POLL_INTERVAL} seconds. Press CTRL+C to stop and view summary."
    echo ""

    # Continuous polling loop
    while true; do
        scan_directory
        sleep "$POLL_INTERVAL"
    done
}

main
