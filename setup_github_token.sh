#!/bin/bash

# This script helps set up a GitHub Personal Access Token with proper format

echo "===== GitHub Token Setup ====="
echo ""
echo "This script will help you set up your GitHub Personal Access Token correctly."
echo "You need a token with 'repo' permissions for the automation to work."
echo ""
echo "Instructions to create a token:"
echo "1. Go to https://github.com/settings/tokens"
echo "2. Click 'Generate new token' (classic)"
echo "3. Give it a name like 'GitHub Streak Automation'"
echo "4. Select the 'repo' scope"
echo "5. Click 'Generate token'"
echo "6. Copy the token (it will only be shown once)"
echo ""
echo "Please enter your GitHub Personal Access Token:"
read -s GITHUB_TOKEN

if [ -z "$GITHUB_TOKEN" ]; then
    echo "Error: Token cannot be empty"
    exit 1
fi

# Update token in all relevant files
echo ""
echo "Updating GitHub token in all scripts..."

# Update token in midnight_commit.sh
sed -i "s/GITHUB_TOKEN=\"[^\"]*\"/GITHUB_TOKEN=\"$GITHUB_TOKEN\"/" /mnt/c/Users/DELL/Desktop/AWS/github-streak/midnight_commit.sh

# Update token in auto_commit.sh if it exists
if [ -f "/mnt/c/Users/DELL/Desktop/AWS/github-streak/auto_commit.sh" ]; then
    sed -i "s/GITHUB_TOKEN=\"[^\"]*\"/GITHUB_TOKEN=\"$GITHUB_TOKEN\"/" /mnt/c/Users/DELL/Desktop/AWS/github-streak/auto_commit.sh
fi

# Update token in push_with_token.sh if it exists
if [ -f "/mnt/c/Users/DELL/Desktop/AWS/github-streak/push_with_token.sh" ]; then
    sed -i "s|https://Anadi-Gupta1:[^@]*@github.com|https://Anadi-Gupta1:$GITHUB_TOKEN@github.com|" /mnt/c/Users/DELL/Desktop/AWS/github-streak/push_with_token.sh
fi

echo "Token updated successfully in all scripts."
echo ""
echo "Testing authentication..."

# Test authentication
cd /mnt/c/Users/DELL/Desktop/AWS/github-streak
git remote set-url origin "https://Anadi-Gupta1:$GITHUB_TOKEN@github.com/Anadi-Gupta1/Daily-commit.git"
git fetch

if [ $? -eq 0 ]; then
    echo "Authentication successful! Your GitHub token is working correctly."
    
    # Push any pending commits
    echo ""
    echo "Would you like to push all pending commits now? (y/n)"
    read push_now
    
    if [[ "$push_now" == "y" || "$push_now" == "Y" ]]; then
        echo "Pushing all commits to GitHub..."
        git push origin main
        
        if [ $? -eq 0 ]; then
            echo "All commits pushed successfully!"
        else
            echo "Failed to push commits. Please check the error message above."
        fi
    fi
else
    echo "Authentication failed. Please check your token and try again."
    echo "Make sure you've created a token with 'repo' permissions."
fi
