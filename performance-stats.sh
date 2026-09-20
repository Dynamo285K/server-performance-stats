#!/usr/bin/env bash

set -euo pipefail

# Total memmory usage
free -m | awk '/^Mem:/ {printf "Memmory used: %d MB / %d MB (%.0f%%)\n", $3, $2, ($3/$2)*100}'

# Total cpu usage
top -bn 2 -d 1 | grep "^%Cpu" | tail -n 1 | awk '{sum = $2 + $4} END {printf "Cpu used: %.1f%%\n", sum}'

# Total disk usage
df -m --total / | grep "total" | awk '{
	total = $2 / 1024;
	used = $3 / 1024;
	available = $4 / 1024;
	reserved = total - used - available;
	printf "Disk used: %.1f G / %.1f G (%.1f%%), because %.1f G reserved for root\n", used, total, $5, reserved}'

# Top 5 cpu usage processes
echo "Top 5 cpu usage processes:"
ps -eo pid,user,%cpu,%mem,comm --sort=-%cpu | head -n 6

# Top 5 mem usage processes 
echo "Top 5 mem usage processes:"
ps -eo pid,user,%cpu,%mem,comm --sort=-%mem | head -n 6

# Os version
source /etc/os-release && echo "$PRETTY_NAME"

# Uptime 
uptime | awk -F',' '{printf "Uptime %s\n", $1}'

# Load average
uptime | awk -F',' '{printf "Load average: %.2f, %.2f, %.2f\n", $3, $4, $5, $6}'
