#!/bin/bash

# This script distributes commits throughout the day
# It will be called by cron once, and then schedules the commits at different times

SCRIPT_PATH="/mnt/c/Users/DELL/Desktop/AWS/github-streak/auto_commit.sh"
LOG_FILE="/mnt/c/Users/DELL/Desktop/AWS/github-streak/commit_log.txt"

# Create log file if it doesn't exist
touch "$LOG_FILE"

# Log start of script
echo "$(date): Starting multi-commit schedule" >> "$LOG_FILE"

# Function to schedule a commit with at
schedule_commit() {
    local time=$1
    local num_commits=$2
    
    # Create a temporary script for this scheduled task
    TEMP_SCRIPT=$(mktemp)
    echo "#!/bin/bash" > "$TEMP_SCRIPT"
    echo "export COMMITS_PER_DAY=$num_commits" >> "$TEMP_SCRIPT"
    echo "$SCRIPT_PATH" >> "$TEMP_SCRIPT"
    echo "echo \"\$(date): Completed $num_commits commits\" >> \"$LOG_FILE\"" >> "$TEMP_SCRIPT"
    chmod +x "$TEMP_SCRIPT"
    
    # Schedule with at
    echo "$TEMP_SCRIPT" | at "$time" 2>/dev/null
    
    echo "$(date): Scheduled $num_commits commits at $time" >> "$LOG_FILE"
}

# Schedule commits at different times
# This distributes 20 commits throughout the day
schedule_commit "9:00 AM" 5
schedule_commit "12:00 PM" 5
schedule_commit "3:00 PM" 5
schedule_commit "6:00 PM" 5

echo "$(date): All commits have been scheduled for today" >> "$LOG_FILE"
