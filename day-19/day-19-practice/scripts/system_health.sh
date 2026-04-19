#!/bin/bash

BASE_DIR="/home/prantonia/projects/30-days-of-linux-learning/day-19/day-19-practice"
LOGFILE="$BASE_DIR/logs/system_health.log"

echo "============================" >> "$LOGFILE"
echo "Run Time: $(date)" >> "$LOGFILE"
echo "" >> "$LOGFILE"

echo "Uptime:" >> "$LOGFILE"
uptime >> "$LOGFILE"
echo "" >> "$LOGFILE"

echo "Disk Usage:" >> "$LOGFILE"
df -h / >> "$LOGFILE"
echo "" >> "$LOGFILE"

echo "Memory Usage:" >> "$LOGFILE"
free -h >> "$LOGFILE"
echo "" >> "$LOGFILE"
