#!/bin/bash
file="test.txt"

if [ -f "$file" ]; then
    echo "File exists"
else
    echo "File does not exist"
fi
