# DEC 30 Days of Linux Challenge

A 30-day structured learning journey from Linux beginner to confident practitioner, documented daily with notes, commands, scripts, and a capstone project.

**Challenge:** DEC (Data Engineering Community) 30 Days of Linux  
**Duration:** 30 days of daily commits  
**Level:** Beginner → Intermediate  
**Focus:** Practical, hands-on Linux skills for data engineering

---

## The Goal

To build a strong foundational understanding of Linux, develop the habit of daily technical practice, and complete a real project that demonstrates the skills learned, all documented publicly on GitHub.

---

## Final Project - Linux Data Pipeline File Monitor

The capstone project (Day 29) is an automated file monitoring and validation system built entirely in Bash. It watches a directory for incoming data files, validates them, logs metadata, moves files through a processing pipeline, and generates a daily summary report.

```
~/pipeline_monitor/
├── pipeline_monitor.sh      # Main monitor - watches incoming/, validates, logs
├── generate_test_data.sh    # Simulates incoming CSV, JSON, and TXT files
├── setup_cron.sh            # Registers the daily summary cron job at 23:59
├── incoming/                # Drop zone for new data files
├── processed/               # Successfully validated files
├── failed/                  # Files that failed validation
├── logs/                    # Daily log files
└── reports/                 # Daily summary reports
```

**Skills used in the project:** Bash scripting, functions, error handling (`set -euo pipefail`), `trap`, `find`, `awk`, `grep`, `wc`, `du`, cron scheduling, structured logging, ANSI terminal output, file validation, and the processed/failed staging pattern used in real ETL pipelines.

**To run it:**
```bash
chmod +x pipeline_monitor.sh generate_test_data.sh setup_cron.sh

# Terminal 1: start the monitor
./pipeline_monitor.sh

# Terminal 2: drop test files
./generate_test_data.sh

# Press CTRL+C in Terminal 1 to stop and view the daily summary
```

---

## 30-Day Curriculum

| Day | Topic | Week |
|-----|-------|------|
| 01 | Linux History & Terminal Setup | Week 1 |
| 02 | Navigating the File System | Week 1 |
| 03 | File and Directory Management | Week 1 |
| 04 | Viewing and Editing Files | Week 1 |
| 05 | Wildcards, Globbing & Bulk File Operations | Week 1 |
| 06 | Help Systems, Command History & Shortcuts | Week 1 |
| 07 | Redirection and Pipes | Week 1 |
| 08 | Search for Files and Content | Week 2 |
| 09 | Package Management | Week 2 |
| 10 | Understanding File Permissions | Week 2 |
| 11 | User and Group Management | Week 2 |
| 12 | Text Processing Tools | Week 2 |
| 13 | Standard Streams and Advanced Redirection | Week 2 |
| 14 | Environment Variables and Shell Configuration | Week 2 |
| 15 | Networking Basics | Week 3 |
| 16 | Introduction to Bash Scripting | Week 3 |
| 17 | Bash Conditionals and Loops | Week 3 |
| 18 | Bash Functions and Script Organization | Week 3 |
| 19 | Cron Jobs and Task Scheduling | Week 3 |
| 20 | SSH and Remote Access | Week 3 |
| 21 | Disk Management and Storage | Week 3 |
| 22 | Systemd and Service Management | Week 4 |
| 23 | Log Management and System Monitoring | Week 4 |
| 24 | Linux Security Basics | Week 4 |
| 25 | Archiving, Compression and Backup | Week 4 |
| 26 | Linux Processes and System Performance | Week 4 |
| 27 | Advanced Bash Scripting | Week 4 |
| 28 | Introduction to Containers (Docker on Linux) | Week 4 |
| 29 | Linux Data Pipeline File Monitor | Final |
| 30 | Reflection | Final |

---

## Tools and Environment

- **OS:** Ubuntu (via WSL2 on Windows / DEC community VM)
- **Editor:** VS Code with WSL integration
- **Version control:** Git + GitHub (daily commits)
- **Container runtime:** Docker Desktop (WSL2 integration)
- **Shell:** Bash

---

## Key Commands Learned

A non-exhaustive reference of the most important commands from the challenge:

```bash
# Navigation and Files
pwd && ls -lah && cd - && mkdir -p && cp -r && mv && rm -i

# Permissions and Users
chmod 755 file && chown user:group file
sudo useradd -m user && sudo usermod -aG sudo user

# Text Processing
grep -in "pattern" file | awk -F: '{print $1}' | sort | uniq -c | sort -rn

# Processes and Performance
ps aux --sort=-%cpu | head -10
htop && kill -15 <PID> && nice -n 10 ./script.sh

# Redirection and Pipes
command > out.txt 2>&1 && command | tee file.txt | grep pattern

# Bash Scripting
set -euo pipefail && trap 'cleanup' EXIT
find . -type f -print0 | while IFS= read -r -d '' f; do ...; done

# System and Services
systemctl status nginx && journalctl -u ssh -f
df -h && du -sh * | sort -rh | head -20

# Networking and Remote
ss -tlnp && curl -I https://example.com
ssh-keygen -t ed25519 && ssh-copy-id user@host

# Docker
docker run -d -p 8081:80 nginx && docker exec -it container bash
docker build -t myapp . && docker logs container

# Backup and Archive
tar -czvf backup_$(date +%Y%m%d).tar.gz ~/project/
rsync -avz --dry-run source/ dest/
```

---

## What's Next

- Set up a personal VPS and deploy the pipeline monitor project in a real environment
- Deepen Docker knowledge: multi-container setups with docker-compose, networking, secrets management
- Learn **Kubernetes**: container orchestration at scale
- Learn **Terraform**: infrastructure as code for cloud environments
- Contribute to an open-source data engineering project that runs on Linux infrastructure

---

## Reflection

I started this challenge not knowing what `/etc` contained or how to exit vim.

Thirty days later I can navigate a Linux file system confidently, write robust bash scripts with proper error handling, manage users and services, monitor system performance, schedule automated tasks, secure a server, and build a working data pipeline tool, all from the terminal.

The most important thing this challenge built was not any individual command. It was the proof that I can show up and learn something technical every single day, even when it is difficult, even when it does not click immediately. That consistency is a skill that transfers to everything else.

Linux is the operating system of the data stack. Understanding it at this level makes every other data engineering tool such as Airflow, Docker, Spark, dbt, more legible, more debuggable, and less intimidating. This challenge was not just about Linux. It was about becoming a more complete data engineer.

---

*DEC 30 Days of Linux Challenge - Completed*  
*30 days · 30 commits · 0 missed days*