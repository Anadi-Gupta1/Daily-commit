#!/bin/bash

# This script updates the GitHub token in all relevant files

# Ask for the new token
echo "Please enter your new GitHub token:"
read -s NEW_TOKEN

if [ -z "$NEW_TOKEN" ]; then
    echo "Error: Token cannot be empty"
    exit 1
fi

echo "Updating GitHub token in all scripts..."

# Update token in auto_commit.sh
sed -i "s/GITHUB_TOKEN=\"[^\"]*\"/GITHUB_TOKEN=\"$NEW_TOKEN\"/" /mnt/c/Users/DELL/Desktop/AWS/github-streak/auto_commit.sh

# Update token in push_with_token.sh
sed -i "s|https://Anadi-Gupta1:[^@]*@github.com|https://Anadi-Gupta1:$NEW_TOKEN@github.com|" /mnt/c/Users/DELL/Desktop/AWS/github-streak/push_with_token.sh

echo "Token updated successfully in all scripts."
echo "Testing authentication..."

# Test authentication
cd /mnt/c/Users/DELL/Desktop/AWS/github-streak
git remote set-url origin "https://Anadi-Gupta1:$NEW_TOKEN@github.com/Anadi-Gupta1/Daily-commit.git"
git fetch

if [ $? -eq 0 ]; then
    echo "Authentication successful! Your GitHub token is working correctly."
else
    echo "Authentication failed. Please check your token and try again."
fi
