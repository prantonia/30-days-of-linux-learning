#!/bin/bash

# setup_cron.sh
# Adds a cron job to run the daily summary report at 11:59 PM every day
# Run once to register the job


set -euo pipefail


BASE_DIR="/home/prantonia/projects/30-days-of-linux-learning/day-29"
SCRIPT_PATH="${BASE_DIR}/pipeline_monitor/pipeline_monitor.sh"
REPORT_SCRIPT="${BASE_DIR}/pipeline_monitor/daily_report_cron.sh"
LOG_DIR="${BASE_DIR}/pipeline_monitor/logs"

# Create a lightweight report-only script for cron
# (cron can't run the interactive monitor, so  generate the summary separately)
cat > "$REPORT_SCRIPT" <<EOF
#!/bin/bash
LOG_DIR="${LOG_DIR}"
REPORT_DIR="${HOME}/pipeline_monitor/reports"
REPORT_FILE="\${REPORT_DIR}/summary_\$(date +%Y-%m-%d).txt"

{
    echo "=== Daily Pipeline Report: \$(date '+%Y-%m-%d %H:%M:%S') ==="
    if [[ -f "\$REPORT_FILE" ]]; then
        total=\$(wc -l < "\$REPORT_FILE")
        processed=\$(grep -c "PROCESSED" "\$REPORT_FILE" || echo 0)
        failed=\$(grep -c "FAILED" "\$REPORT_FILE" || echo 0)
        echo "Total: \$total | Processed: \$processed | Failed: \$failed"
        cat "\$REPORT_FILE"
    else
        echo "No report file found for today."
    fi
} >> "\${LOG_DIR}/cron_summary_\$(date +%Y-%m-%d).log" 2>&1
EOF

chmod +x "$REPORT_SCRIPT"

# Add to crontab (runs daily at 23:59)
CRON_JOB="59 23 * * * ${REPORT_SCRIPT}"

# Check if already registered
if crontab -l 2>/dev/null | grep -q "$REPORT_SCRIPT"; then
    echo "Cron job already registered. No changes made."
else
    (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
    echo " Cron job registered: daily report at 23:59"
    echo "  Script : $REPORT_SCRIPT"
    echo "  Output : ${LOG_DIR}/cron_summary_YYYY-MM-DD.log"
fi

echo ""
echo "Verify with: crontab -l"
