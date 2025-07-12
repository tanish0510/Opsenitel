#!/bin/bash

REPORT="full_system_report.txt"
SEPARATOR="----------------------------------------"

# === Start of Report ===
echo "========== Full System Debug Report ==========" > "$REPORT"
echo "Generated on: $(date)" >> "$REPORT"
echo "$SEPARATOR" >> "$REPORT"

# === System Uptime ===
uptime_info=$(uptime)
echo "System Uptime:" >> "$REPORT"
echo "$uptime_info" >> "$REPORT"
echo "$SEPARATOR" >> "$REPORT"

# === Disk Usage (Root Partition) ===
disk_usage=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
echo "Disk Usage:" >> "$REPORT"
echo "Root (/) Usage: ${disk_usage}%" >> "$REPORT"

if [ "$disk_usage" -ge 2 ]; then
    echo "Warning: Disk usage is critically high." >> "$REPORT"
else
    echo "Disk usage is within safe limits." >> "$REPORT"
fi
echo "$SEPARATOR" >> "$REPORT"

# === Logged-in Users ===
user_count=$(who | awk '{print $1}'|sort | uniq )
echo "Active Sessions:" >> "$REPORT"
echo "Currently logged in users: $user_count" >> "$REPORT"

if [ "$user_count" -ge 5 ]; then
    echo "High user activity detected." >> "$REPORT"
else
    echo "Normal user activity." >> "$REPORT"
fi
echo "$SEPARATOR" >> "$REPORT"

# === OS Version ===
echo "OS Information:" >> "$REPORT"
if [ -f /etc/os-release ]; then
    while IFS= read -r line
    do
        echo "$line" >> "$REPORT"
    done < /etc/os-release
else
    echo "Could not determine OS version." >> "$REPORT"
fi
echo "$SEPARATOR" >> "$REPORT"

# === CPU Load Average ===
cpu_load=$(uptime | awk -F'load averages: ' '{ print $2 }')
echo "CPU Load Averages:" >> "$REPORT"
echo "$cpu_load" >> "$REPORT"

load_1min=$(echo "$cpu_load" | awk '{print $1}')
if (( $(echo "$load_1min > 5.0" | bc -l) )); then
    echo "High CPU load detected." >> "$REPORT"
else
    echo "CPU load is normal." >> "$REPORT"
fi
echo "$SEPARATOR" >> "$REPORT"

# === Final Summary ===
echo "Final Summary:" >> "$REPORT"
for section in "Disk Usage" "User Sessions" "CPU Load"
do
    echo "- Checked $section status." >> "$REPORT"
done

echo "$SEPARATOR" >> "$REPORT"
echo "System audit completed successfully." >> "$REPORT"
echo "Report saved to: $REPORT"

