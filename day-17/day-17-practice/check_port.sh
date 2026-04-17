#!/bin/bash

port=8080

if ss -tln | grep -q ":$port"; then
    echo "Port $port is running"
else
    echo "Port $port is not running"
fi
