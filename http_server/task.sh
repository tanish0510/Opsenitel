#!/bin/bash
set -e

OUTPUT="system_analysis.txt"
HTML_FILE="index.html"

# === System Maintenance Report ===
echo "<--- System Maintenance Report --->" > "$OUTPUT"

# Uptime and Users
uptime_output=$(uptime)
users_online=$(who | awk '{print $1}' | sort | uniq )
echo "Uptime: $uptime_output" >> "$OUTPUT"
echo "Users online: $users_online" >> "$OUTPUT"

# === Temp File Archiving ===
source_path="/tmp"
backup_path="/Users/tanish.seth/backup"
# cd "$source_path"
# gzip *.txt 
# mv *.gz "$backup_path" 
# echo "Temp files from $source_path compressed and moved to $backup_path." >> "$OUTPUT"
# cd ~/

# === Disk Usage Summary ===
# DISK=$(top -l 1 | awk '/PhysMem/ {sub(/M$/, "", $2); sub(/M$/, "", $6); used=$2; total=$2+$6; printf("%.2f%%\n", used/total*100)}')
# echo "Disk usage: $DISK" >> "$OUTPUT"

ANS=$(df -h | awk 'NR==1 {print $5, "|", $9} /\/dev/ {print $5, "|", $9}')
echo "Disk capacity and mounts:" >> "$OUTPUT"
echo "$ANS" >> "$OUTPUT"

# === Temp Files Count ===
cleaned_files=$(find "$backup_path" -name "*.gz" | wc -l)
echo "Total temp cleaned files: $cleaned_files" >> "$OUTPUT"

# === Top 3 Large Log Files ===
LOG=$(find /var/log -type f -name "*.log" -size +5M -exec du -h {} + | sort -hr | head -n 3)
echo "Top 3 log files larger than 5MB:" >> "$OUTPUT"
echo "$LOG" >> "$OUTPUT"

# === Audit User Activity ===
echo "Recent login activity:" >> "$OUTPUT"
last_output=$(last -10)
echo "$last_output" >> "$OUTPUT"

# ===== HTML =====
{
echo "<!DOCTYPE html>"
echo "<html><head><title>System Maintenance Report</title></head><body>"
echo "<h1>System Maintenance Report</h1>"

echo "<h2>System Uptime</h2><pre>$uptime_output</pre>"
echo "<h2>Total Users Online</h2><pre>$users_online</pre>"

# echo "<h2>Disk Usage</h2><pre>$DISK</pre>"

echo "<h2>Disk Capacity and Mounts</h2><pre>"
echo "$ANS"
echo "</pre>"

echo "<h2>Total Temp Files Cleaned</h2><pre>$cleaned_files</pre>"

echo "<h2>Top 3 Large Log Files</h2><pre>"
echo "$LOG"
echo "</pre>"

echo "<h2>Recent Login Activity</h2><pre>"
echo "$last_output"
echo "</pre>"

echo "<h2>System Analysis (Raw)</h2><pre>"
cat "$OUTPUT"
echo "</pre>"

echo "</body></html>"
} > "$HTML_FILE"
