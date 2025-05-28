#!/bin/bash

# This script sets up a cron job to run the midnight_commit.sh script daily at midnight

# Path to the midnight commit script
SCRIPT_PATH="/mnt/c/Users/DELL/Desktop/AWS/github-streak/midnight_commit.sh"

# Check if the script exists
if [ ! -f "$SCRIPT_PATH" ]; then
    echo "Error: Midnight commit script not found at $SCRIPT_PATH"
    exit 1
fi

# Make sure the script is executable
chmod +x "$SCRIPT_PATH"

# Create a temporary file for the crontab
TEMP_CRON=$(mktemp)

# Export current crontab
crontab -l > "$TEMP_CRON" 2>/dev/null

# Remove any existing cron jobs for the old automation
sed -i "\|/mnt/c/Users/DELL/Desktop/AWS/github-streak/multi_commit_schedule.sh|d" "$TEMP_CRON"
sed -i "\|/mnt/c/Users/DELL/Desktop/AWS/github-streak/auto_commit.sh|d" "$TEMP_CRON"

# Check if the midnight cron job already exists
if grep -q "$SCRIPT_PATH" "$TEMP_CRON"; then
    echo "Midnight cron job already exists. Updating..."
    sed -i "\|$SCRIPT_PATH|d" "$TEMP_CRON"
fi

# Add the new cron job - runs at midnight (00:00) daily
echo "0 0 * * * $SCRIPT_PATH" >> "$TEMP_CRON"

# Install the new crontab
crontab "$TEMP_CRON"

# Remove the temporary file
rm "$TEMP_CRON"

echo "Cron job setup complete. The midnight commit script will run daily at 12:00 AM."
echo "This will make all $COMMITS_PER_DAY commits at once."
echo "You can verify your crontab with: crontab -l"

# Ask for GitHub token to update in the script
echo ""
echo "Would you like to update your GitHub token in the midnight commit script? (y/n)"
read -r update_token

if [[ "$update_token" == "y" || "$update_token" == "Y" ]]; then
    echo "Please enter your GitHub Personal Access Token:"
    read -s GITHUB_TOKEN
    
    if [ -z "$GITHUB_TOKEN" ]; then
        echo "Error: Token cannot be empty"
        exit 1
    fi
    
    # Update token in midnight_commit.sh
    sed -i "s/GITHUB_TOKEN=\"[^\"]*\"/GITHUB_TOKEN=\"$GITHUB_TOKEN\"/" "$SCRIPT_PATH"
    echo "GitHub token updated successfully in the midnight commit script."
fi

echo ""
echo "Midnight commit automation setup complete!"
