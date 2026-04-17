#!/bin/bash

for file in *.log
do
    echo "Processing $file..."
    grep -i "error" "$file" >> errors_summary.txt
done

echo "Error extraction complete."
