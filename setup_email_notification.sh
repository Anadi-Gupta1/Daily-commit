#!/bin/bash

# This script sets up the email notification system for GitHub streak updates

# Configuration
EMAIL_SCRIPT_PATH="/mnt/c/Users/DELL/Desktop/AWS/github-streak/email_notification.py"

# Make sure the script is executable
chmod +x "$EMAIL_SCRIPT_PATH"

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "Python 3 is required but not installed. Please install Python 3."
    exit 1
fi

# Install required Python packages
echo "Installing required Python packages..."
pip3 install --user smtplib || echo "Note: smtplib is part of Python standard library"

# Ask for Gmail account details
echo ""
echo "To send email notifications, you need to set up a Gmail account."
echo "It's recommended to create a new Gmail account specifically for this purpose."
echo ""
echo "Please enter the Gmail address to send notifications from:"
read SENDER_EMAIL

echo "Please enter an App Password for this Gmail account:"
echo "(You can create an App Password in your Google Account settings)"
echo "Instructions: https://support.google.com/accounts/answer/185833"
read -s APP_PASSWORD

echo ""
echo "Updating email notification script with your credentials..."

# Update the email script with the provided credentials
sed -i "s/SENDER_EMAIL = \"[^\"]*\"/SENDER_EMAIL = \"$SENDER_EMAIL\"/" "$EMAIL_SCRIPT_PATH"
sed -i "s/SENDER_PASSWORD = \"[^\"]*\"/SENDER_PASSWORD = \"$APP_PASSWORD\"/" "$EMAIL_SCRIPT_PATH"

echo "Email notification setup complete!"
echo ""
echo "To test the email notification system, run:"
echo "python3 $EMAIL_SCRIPT_PATH success 20"
echo ""
echo "Now let's update the midnight_commit.sh script to send email notifications..."

# Update the midnight_commit.sh script to include email notifications
MIDNIGHT_SCRIPT="/mnt/c/Users/DELL/Desktop/AWS/github-streak/midnight_commit.sh"

# Check if the script exists
if [ ! -f "$MIDNIGHT_SCRIPT" ]; then
    echo "Error: midnight_commit.sh not found at $MIDNIGHT_SCRIPT"
    exit 1
fi

# Add email notification to the script
sed -i '/echo "===== Midnight Commit Process Completed =====" >> "$LOG_FILE"/a\
\
# Send email notification\
python3 "$REPO_PATH\/email_notification.py" success "$COMMITS_PER_DAY" || echo "Failed to send email notification"' "$MIDNIGHT_SCRIPT"

# Add email notification for failure case
sed -i '/echo "Failed to push commits to GitHub" >> "$LOG_FILE"/a\    python3 "$REPO_PATH\/email_notification.py" failure "$COMMITS_PER_DAY" || echo "Failed to send email notification"' "$MIDNIGHT_SCRIPT"

echo "Midnight commit script updated to send email notifications!"
echo ""
echo "Setup complete! You will now receive email notifications at anadigupta55555@gmail.com"
echo "whenever your GitHub streak is updated."
