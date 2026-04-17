#!/bin/bash

count=1

while [ $count -le 5 ]
do
    if ping -c 1 google.com > /dev/null 2>&1; then
        echo "Internet is reachable"
        break
    else
        echo "Retry $count..."
    fi
    ((count++))
done

