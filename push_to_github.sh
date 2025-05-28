#!/bin/bash

# Script to push commits to GitHub
# This will help you see green contribution blocks

# Navigate to repository
cd /mnt/c/Users/DELL/Desktop/AWS/github-green-blocks

# Set up GitHub credentials in git config
# This avoids having to enter them when pushing
git config credential.helper store

# Push to GitHub
echo "Pushing commits to GitHub..."
git push -u origin main

echo ""
echo "Commits have been pushed to GitHub!"
echo "Visit https://github.com/Anadi-Gupta1 to see your green contribution blocks."
echo ""
echo "Note: It may take a few minutes for GitHub to update your contribution graph."
