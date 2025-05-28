#!/bin/bash

# This script will push to GitHub using your token
cd /mnt/c/Users/DELL/Desktop/AWS/github-streak

# The URL format with embedded token
# Format: https://<username>:<token>@github.com/<username>/<repo>.git
GITHUB_URL="https://Anadi-Gupta1:YOUR_GITHUB_TOKEN_HERE@github.com/Anadi-Gupta1/Daily-commit.git"

# Set the remote URL with the token
git remote set-url origin "$GITHUB_URL"

# Push to GitHub
git push -u origin main

echo "Push attempt completed. Check for any errors above."
