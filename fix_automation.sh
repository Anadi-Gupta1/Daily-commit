#!/bin/bash

# This script fixes the GitHub streak automation issues

echo "Fixing GitHub streak automation..."

# 1. Install the 'at' daemon if not already installed
echo "Installing 'at' daemon..."
sudo apt-get update
sudo apt-get install -y at
sudo systemctl enable --now atd
echo "at daemon installation completed."

# 2. Update email in auto_commit.sh
echo "Updating GitHub email in scripts..."
sed -i 's/your-email@example.com/anadigupta55555@gmail.com/' /mnt/c/Users/DELL/Desktop/AWS/github-streak/auto_commit.sh
echo "Email updated."

# 3. Create a test file to verify everything works
echo "Creating test file..."
echo "# Automation Fix Test" > /mnt/c/Users/DELL/Desktop/AWS/github-streak/automation_fixed.md
echo "Fixed on: $(date)" >> /mnt/c/Users/DELL/Desktop/AWS/github-streak/automation_fixed.md
echo "Test file created."

# 4. Verify cron job is set up correctly
echo "Verifying cron job..."
CRON_CHECK=$(crontab -l | grep "multi_commit_schedule.sh")
if [ -z "$CRON_CHECK" ]; then
    echo "Cron job not found. Setting up cron job..."
    (crontab -l 2>/dev/null; echo "0 8 * * * /mnt/c/Users/DELL/Desktop/AWS/github-streak/multi_commit_schedule.sh") | crontab -
    echo "Cron job added."
else
    echo "Cron job already exists."
fi

echo "Automation fix completed. Your GitHub streak should now work properly every day."
echo "Remember to update your GitHub token if it has expired."
echo "You can generate a new token at: https://github.com/settings/tokens"
