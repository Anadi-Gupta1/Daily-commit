#!/bin/bash

# Configuration
REPO_PATH="/mnt/c/Users/DELL/Desktop/AWS/github-streak"
GITHUB_EMAIL="anadigupta55555@gmail.com"
GITHUB_USERNAME="Anadi-Gupta1"
GITHUB_TOKEN="tthel"  # Replace with your actual token
COMMITS_PER_DAY=20  # Number of commits to make at midnight
NOTIFICATION_EMAIL="anadigupta55555@gmail.com"  # Email to send notifications to

# Log file
LOG_FILE="$REPO_PATH/midnight_commit_log.txt"

# Start logging
echo "===== Midnight Commit Process Started =====" >> "$LOG_FILE"
echo "Started at: $(date)" >> "$LOG_FILE"

# Navigate to repository
cd $REPO_PATH || {
    echo "Failed to navigate to repository path" >> "$LOG_FILE"
    
    # Try to send failure notification via the Python script if available
    if [ -f "$REPO_PATH/email_notification.py" ]; then
        python3 "$REPO_PATH/email_notification.py" failure 0 || echo "Failed to send email notification"
    fi
    
    exit 1
}

# Set remote URL with token for authentication
git remote set-url origin "https://$GITHUB_USERNAME:$GITHUB_TOKEN@github.com/$GITHUB_USERNAME/Daily-commit.git"

# Configure git with the correct email
git config user.email "$GITHUB_EMAIL"
git config user.name "$GITHUB_USERNAME"

# Pull latest changes to avoid conflicts
git pull origin main || {
    echo "Failed to pull latest changes" >> "$LOG_FILE"
    # Continue anyway as this might be due to no changes
}

# Function to make a single commit
make_commit() {
    local commit_number=$1
    local current_time=$(date +"%Y-%m-%d %H:%M:%S")
    
    # Create a new file for each commit to ensure uniqueness
    local filename="commit_files/midnight_commit_${current_time// /_}_$commit_number.md"
    
    # Create directory if it doesn't exist
    mkdir -p commit_files
    
    # Create a unique file with content
    echo "# Midnight Commit File $commit_number" > "$filename"
    echo "" >> "$filename"
    echo "This is a unique file created for midnight commit $commit_number." >> "$filename"
    echo "Created at: $current_time" >> "$filename"
    echo "Random value: $RANDOM" >> "$filename"

    # Also update the streak file to maintain consistency
    echo "# Streak Tracker" > streak.md
    echo "" >> streak.md
    echo "This file is updated regularly to maintain GitHub activity." >> streak.md
    echo "" >> streak.md
    echo "Last update: $current_time" >> streak.md
    echo "Midnight commit number: $commit_number of $COMMITS_PER_DAY" >> streak.md
    echo "Random value: $RANDOM" >> streak.md

    # Commit and push changes
    git add "$filename" streak.md
    git commit -m "Midnight update $commit_number/$COMMITS_PER_DAY: $current_time"
    
    echo "Commit $commit_number/$COMMITS_PER_DAY prepared at $current_time" >> "$LOG_FILE"
    
    # Add a small delay between commits to ensure they're distinct
    sleep 1
}

# Make multiple commits
echo "Starting midnight commit process - making $COMMITS_PER_DAY commits" >> "$LOG_FILE"
for i in $(seq 1 $COMMITS_PER_DAY); do
    make_commit $i
done

# Push all commits at once
echo "Pushing all commits to GitHub..." >> "$LOG_FILE"
git push origin main || {
    echo "Failed to push commits to GitHub" >> "$LOG_FILE"
    python3 "$REPO_PATH/email_notification.py" failure "$COMMITS_PER_DAY" || echo "Failed to send email notification"
    python3 "$REPO_PATH/email_notification.py" failure "$COMMITS_PER_DAY" || echo "Failed to send email notification"
    
    # Send failure notification via the Python script if available
    if [ -f "$REPO_PATH/email_notification.py" ]; then
        python3 "$REPO_PATH/email_notification.py" failure "$COMMITS_PER_DAY" || echo "Failed to send email notification"
    fi
    
    exit 1
}

echo "All $COMMITS_PER_DAY commits pushed successfully at $(date)" >> "$LOG_FILE"
echo "===== Midnight Commit Process Completed =====" >> "$LOG_FILE"

# Send email notification
python3 "$REPO_PATH/email_notification.py" success "$COMMITS_PER_DAY" || echo "Failed to send email notification"

# Send email notification
python3 "$REPO_PATH/email_notification.py" success "$COMMITS_PER_DAY" || echo "Failed to send email notification"

# Send success notification via the Python script if available
if [ -f "$REPO_PATH/email_notification.py" ]; then
    python3 "$REPO_PATH/email_notification.py" success "$COMMITS_PER_DAY" || echo "Failed to send email notification"
fi
