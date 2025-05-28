#!/bin/bash

# This script distributes commits throughout the day
# It will be called by cron once, and then schedules the commits at different times

REPO_PATH="/mnt/c/Users/DELL/Desktop/AWS/github-streak"
SCRIPT_PATH="$REPO_PATH/auto_commit.sh"
LOG_FILE="$REPO_PATH/commit_log.txt"

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
    echo "cd $REPO_PATH" >> "$TEMP_SCRIPT"
    echo "export COMMITS_PER_DAY=$num_commits" >> "$TEMP_SCRIPT"
    echo "$SCRIPT_PATH" >> "$TEMP_SCRIPT"
    echo "echo \"\$(date): Completed $num_commits commits\" >> \"$LOG_FILE\"" >> "$TEMP_SCRIPT"
    chmod +x "$TEMP_SCRIPT"
    
    # Schedule with at
    echo "$TEMP_SCRIPT" | at "$time" 2>/dev/null
    
    echo "$(date): Scheduled $num_commits commits at $time" >> "$LOG_FILE"
}

# Get current hour to determine scheduling
CURRENT_HOUR=$(date +%H)
CURRENT_HOUR_NUM=$((10#$CURRENT_HOUR))

# Schedule commits based on current time
if [ $CURRENT_HOUR_NUM -lt 9 ]; then
    # Before 9 AM - schedule all 4 batches
    schedule_commit "9:00 AM" 5
    schedule_commit "12:00 PM" 5
    schedule_commit "3:00 PM" 5
    schedule_commit "6:00 PM" 5
elif [ $CURRENT_HOUR_NUM -lt 12 ]; then
    # Between 9 AM and 12 PM - schedule remaining 3 batches
    schedule_commit "12:00 PM" 5
    schedule_commit "3:00 PM" 5
    schedule_commit "6:00 PM" 5
elif [ $CURRENT_HOUR_NUM -lt 15 ]; then
    # Between 12 PM and 3 PM - schedule remaining 2 batches
    schedule_commit "3:00 PM" 5
    schedule_commit "6:00 PM" 5
elif [ $CURRENT_HOUR_NUM -lt 18 ]; then
    # Between 3 PM and 6 PM - schedule last batch
    schedule_commit "6:00 PM" 5
else
    # After 6 PM - schedule a small batch for later tonight
    schedule_commit "9:00 PM" 5
fi

echo "$(date): All commits have been scheduled for today" >> "$LOG_FILE"
