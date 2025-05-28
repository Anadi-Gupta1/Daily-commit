#!/bin/bash

# This script sets up the complete automation for GitHub streak maintenance
# It will:
# 1. Update the token in all scripts
# 2. Set up the cron job to run daily
# 3. Run the first commit batch immediately

# Configuration
REPO_PATH="/mnt/c/Users/DELL/Desktop/AWS/github-streak"
GITHUB_EMAIL="anadigupta55555@gmail.com"
GITHUB_USERNAME="Anadi-Gupta1"
CRON_SCRIPT_PATH="$REPO_PATH/multi_commit_schedule.sh"
AUTO_COMMIT_SCRIPT="$REPO_PATH/auto_commit.sh"
UPDATE_TOKEN_SCRIPT="$REPO_PATH/update_token.sh"
LOG_FILE="$REPO_PATH/automation_setup.log"

# Start logging
echo "===== GitHub Streak Automation Setup =====" > "$LOG_FILE"
echo "Started at: $(date)" >> "$LOG_FILE"

# Function to log messages
log_message() {
    echo "$(date): $1" >> "$LOG_FILE"
    echo "$1"
}

# Check if scripts exist
if [ ! -f "$AUTO_COMMIT_SCRIPT" ]; then
    log_message "Error: Auto commit script not found at $AUTO_COMMIT_SCRIPT"
    exit 1
fi

if [ ! -f "$UPDATE_TOKEN_SCRIPT" ]; then
    log_message "Error: Token update script not found at $UPDATE_TOKEN_SCRIPT"
    exit 1
fi

# Make scripts executable
chmod +x "$AUTO_COMMIT_SCRIPT"
chmod +x "$UPDATE_TOKEN_SCRIPT"
chmod +x "$CRON_SCRIPT_PATH"

log_message "All scripts made executable"

# Ask for GitHub token
log_message "Setting up GitHub token..."
echo "Please enter your GitHub Personal Access Token:"
read -s GITHUB_TOKEN

if [ -z "$GITHUB_TOKEN" ]; then
    log_message "Error: Token cannot be empty"
    exit 1
fi

# Update token in auto_commit.sh
sed -i "s/GITHUB_TOKEN=\"[^\"]*\"/GITHUB_TOKEN=\"$GITHUB_TOKEN\"/" "$AUTO_COMMIT_SCRIPT"

# Update token in push_with_token.sh if it exists
PUSH_TOKEN_SCRIPT="$REPO_PATH/push_with_token.sh"
if [ -f "$PUSH_TOKEN_SCRIPT" ]; then
    sed -i "s|https://$GITHUB_USERNAME:[^@]*@github.com|https://$GITHUB_USERNAME:$GITHUB_TOKEN@github.com|" "$PUSH_TOKEN_SCRIPT"
    chmod +x "$PUSH_TOKEN_SCRIPT"
fi

log_message "GitHub token updated in all scripts"

# Test authentication
cd "$REPO_PATH" || exit 1
git remote set-url origin "https://$GITHUB_USERNAME:$GITHUB_TOKEN@github.com/$GITHUB_USERNAME/Daily-commit.git"
git fetch

if [ $? -eq 0 ]; then
    log_message "Authentication successful! GitHub token is working correctly."
else
    log_message "Authentication failed. Please check your token and try again."
    exit 1
fi

# Set up cron job
log_message "Setting up cron job..."

# Create a temporary file for the crontab
TEMP_CRON=$(mktemp)

# Export current crontab
crontab -l > "$TEMP_CRON" 2>/dev/null

# Check if the cron job already exists
if grep -q "$CRON_SCRIPT_PATH" "$TEMP_CRON"; then
    log_message "Cron job already exists. Updating..."
    sed -i "\|$CRON_SCRIPT_PATH|d" "$TEMP_CRON"
fi

# Add the new cron job - runs at 8 AM daily to schedule the day's commits
echo "0 8 * * * $CRON_SCRIPT_PATH" >> "$TEMP_CRON"

# Install the new crontab
crontab "$TEMP_CRON"

# Remove the temporary file
rm "$TEMP_CRON"

log_message "Cron job setup complete. The multi-commit schedule script will run daily at 8 AM."

# Run the first batch of commits immediately
log_message "Running first batch of commits..."

# Create a temporary script for immediate execution
TEMP_IMMEDIATE_SCRIPT=$(mktemp)
echo "#!/bin/bash" > "$TEMP_IMMEDIATE_SCRIPT"
echo "export COMMITS_PER_DAY=5" >> "$TEMP_IMMEDIATE_SCRIPT"
echo "$AUTO_COMMIT_SCRIPT" >> "$TEMP_IMMEDIATE_SCRIPT"
echo "echo \"\$(date): Completed initial 5 commits\" >> \"$LOG_FILE\"" >> "$TEMP_IMMEDIATE_SCRIPT"
chmod +x "$TEMP_IMMEDIATE_SCRIPT"

# Run in background
nohup "$TEMP_IMMEDIATE_SCRIPT" > /dev/null 2>&1 &

log_message "Initial commit batch started in background"
log_message "The remaining commits will be scheduled throughout the day"

# Schedule the rest of today's commits
log_message "Scheduling remaining commits for today..."
"$CRON_SCRIPT_PATH"

log_message "===== Automation Setup Complete ====="
log_message "Your GitHub streak will now be maintained automatically."
log_message "Check $LOG_FILE for ongoing logs."

echo ""
echo "===== GitHub Streak Automation Setup Complete ====="
echo "Your GitHub streak will now be maintained automatically."
echo "The system will make commits throughout the day, every day."
echo "Check $LOG_FILE for logs."
