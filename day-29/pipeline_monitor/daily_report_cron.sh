#!/bin/bash
LOG_DIR="/home/prantonia/projects/30-days-of-linux-learning/day-29/pipeline_monitor/logs"
REPORT_DIR="/home/prantonia/pipeline_monitor/reports"
REPORT_FILE="${REPORT_DIR}/summary_$(date +%Y-%m-%d).txt"

{
    echo "=== Daily Pipeline Report: $(date '+%Y-%m-%d %H:%M:%S') ==="
    if [[ -f "$REPORT_FILE" ]]; then
        total=$(wc -l < "$REPORT_FILE")
        processed=$(grep -c "PROCESSED" "$REPORT_FILE" || echo 0)
        failed=$(grep -c "FAILED" "$REPORT_FILE" || echo 0)
        echo "Total: $total | Processed: $processed | Failed: $failed"
        cat "$REPORT_FILE"
    else
        echo "No report file found for today."
    fi
} >> "${LOG_DIR}/cron_summary_$(date +%Y-%m-%d).log" 2>&1
