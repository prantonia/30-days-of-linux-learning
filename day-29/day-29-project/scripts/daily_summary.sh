#!/bin/bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
LOG_FILE="$BASE_DIR/logs/pipeline_monitor.log"
REPORT_FILE="$BASE_DIR/reports/daily_summary_$(date +%F).txt"

mkdir -p "$BASE_DIR/reports"

{
    echo "Daily Pipeline Summary"
    echo "Date: $(date +%F)"
    echo "Generated: $(date)"
    echo

    echo "Total files processed:"
    wc -l < "$LOG_FILE"

    echo
    echo "Accepted files:"
    grep -c "|ACCEPTED|" "$LOG_FILE" || true

    echo
    echo "Rejected files:"
    grep -c "|REJECTED|" "$LOG_FILE" || true

    echo
    echo "Files by status:"
    awk -F'|' '{count[$2]++} END {for (status in count) print status, count[status]}' "$LOG_FILE"

    echo
    echo "Total bytes processed:"
    awk -F'|' '{sum += $4} END {print sum+0}' "$LOG_FILE"

    echo
    echo "Recent log entries:"
    tail -n 10 "$LOG_FILE"

} > "$REPORT_FILE"

echo "Report created: $REPORT_FILE"
