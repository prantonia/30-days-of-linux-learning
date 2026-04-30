#!/bin/bash

# generate_test_data.sh
# Simulates incoming data files dropping into the watch directory
# Run this in a separate terminal while pipeline_monitor.sh is running


set -euo pipefail


BASE_DIR="/home/prantonia/projects/30-days-of-linux-learning/day-29"
WATCH_DIR="${BASE_DIR}/pipeline_monitor/incoming"


GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Test Data Generator — DEC 30 Days of Linux Day 29${NC}"
echo "Dropping test files into: $WATCH_DIR"
echo ""

# --- Valid CSV file ---
cat > "${WATCH_DIR}/sales_2024_01.csv" <<EOF
date,product,quantity,revenue
2024-01-01,Widget A,120,2400.00
2024-01-01,Widget B,85,3400.00
2024-01-02,Widget A,95,1900.00
2024-01-02,Widget C,200,5000.00
2024-01-03,Widget B,110,4400.00
EOF
echo -e "$ Dropped: sales_2024_01.csv (valid CSV, 5 data rows)${NC}"
sleep 2

# --- Valid JSON file ---
cat > "${WATCH_DIR}/users_export.json" <<EOF
[
{"id": 1, "name": "Alice", "role": "engineer", "active": true},
{"id": 2, "name": "Bob", "role": "analyst", "active": true},
{"id": 3, "name": "Carol", "role": "manager", "active": false},
{"id": 4, "name": "Dave", "role": "engineer", "active": true}
]
EOF
echo -e "$ Dropped: users_export.json (valid JSON, 4 records)${NC}"
sleep 2

# --- Valid TXT file ---
cat > "${WATCH_DIR}/pipeline_events.txt" <<EOF
2024-01-15 08:00:01 Pipeline started
2024-01-15 08:01:22 Extracted 5000 rows from source
2024-01-15 08:02:45 Transformation complete
2024-01-15 08:03:10 Loaded 4998 rows to destination
2024-01-15 08:03:11 2 rows rejected (schema mismatch)
2024-01-15 08:03:12 Pipeline finished
EOF
echo -e "$ Dropped: pipeline_events.txt (valid TXT, 6 lines)${NC}"
sleep 2

# --- Invalid: empty file ---
touch "${WATCH_DIR}/empty_file.csv"
echo -e "$ Dropped: empty_file.csv (invalid — empty file)${NC}"
sleep 2

# --- Invalid: unsupported extension ---
cat > "${WATCH_DIR}/config.xml" <<EOF
<config><env>production</env></config>
EOF
echo -e "$ Dropped: config.xml (invalid — unsupported extension)${NC}"
sleep 2

# --- Valid CSV: second batch ---
cat > "${WATCH_DIR}/inventory_check.csv" <<EOF
sku,warehouse,stock,reorder_point
SKU-001,Lagos,450,100
SKU-002,Abuja,23,50
SKU-003,PH,891,200
SKU-004,Kano,0,75
EOF
echo -e "$ Dropped: inventory_check.csv (valid CSV, 4 data rows)${NC}"

echo ""
echo "All test files dropped. Switch to your monitor terminal to see results."
echo "Then press CTRL+C in the monitor to generate the daily summary report."
