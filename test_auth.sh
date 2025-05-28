#!/bin/bash

# This script will test GitHub authentication
cd /mnt/c/Users/DELL/Desktop/AWS/github-streak

# Update a file
echo "Authentication test: $(date)" >> auth_test.md

# Add and commit
git add auth_test.md
git commit -m "Testing GitHub authentication"

# Push to GitHub
git push origin main

echo "If no errors appear above, authentication is working correctly!"
