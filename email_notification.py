#!/usr/bin/env python3

import smtplib
import sys
import os
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from datetime import datetime

# Configuration
RECIPIENT_EMAIL = "anadigupta55555@gmail.com"
SENDER_EMAIL = "anadigupta55555@gmail.com"  # You'll need to set up this account
SENDER_PASSWORD = "2024"  # Use an app password, not your regular password

def send_email(subject, message_body, success=True):
    """Send an email notification about GitHub commits"""
    try:
        # Create message
        msg = MIMEMultipart()
        msg['From'] = SENDER_EMAIL
        msg['To'] = RECIPIENT_EMAIL
        msg['Subject'] = subject
        
        # Add body
        msg.attach(MIMEText(message_body, 'plain'))
        
        # Connect to Gmail
        server = smtplib.SMTP('smtp.gmail.com', 587)
        server.starttls()
        server.login(SENDER_EMAIL, SENDER_PASSWORD)
        
        # Send email
        server.send_message(msg)
        server.quit()
        
        print(f"Email notification sent to {RECIPIENT_EMAIL}")
        return True
    except Exception as e:
        print(f"Failed to send email: {str(e)}")
        return False

def main():
    # Check arguments
    if len(sys.argv) < 3:
        print("Usage: python3 email_notification.py <success|failure> <num_commits>")
        sys.exit(1)
    
    status = sys.argv[1]
    num_commits = sys.argv[2]
    
    # Current date and time
    now = datetime.now()
    date_str = now.strftime("%Y-%m-%d")
    time_str = now.strftime("%H:%M:%S")
    
    # Create appropriate message based on status
    if status == "success":
        subject = f"✅ GitHub Streak Updated Successfully - {date_str}"
        message = f"""
Hello,

Your GitHub streak has been successfully updated!

Date: {date_str}
Time: {time_str}
Number of commits: {num_commits}
Repository: Daily-commit

All commits were successfully pushed to your GitHub repository.
Your contribution graph should now show activity for today.

No action is needed from your side.

Best regards,
GitHub Streak Automation
"""
    else:
        subject = f"❌ GitHub Streak Update FAILED - {date_str}"
        message = f"""
Hello,

There was a problem updating your GitHub streak!

Date: {date_str}
Time: {time_str}
Repository: Daily-commit

The automation script encountered an error while trying to push commits.
Please check the logs at: /mnt/c/Users/DELL/Desktop/AWS/github-streak/midnight_commit_log.txt

You may need to:
1. Check your GitHub token validity
2. Run the update_token.sh script
3. Manually push commits for today

Best regards,
GitHub Streak Automation
"""
    
    # Send the email
    send_email(subject, message, status == "success")

if __name__ == "__main__":
    main()
