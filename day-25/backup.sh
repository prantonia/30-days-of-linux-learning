#!/bin/bash
DATE=$(date +%F)
tar -czf backup-$DATE.tar.gz ~/projects/30-days-of-linux-learning
echo "Backup created: backup-$DATE.tar.gz"
