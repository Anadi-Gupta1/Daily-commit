#!/bin/bash

# This script fixes commit email and makes additional commits to ensure green blocks

# Configuration
REPO_PATH="/mnt/c/Users/DELL/Desktop/AWS/github-streak"
GITHUB_USERNAME="Anadi-Gupta1"
GITHUB_TOKEN="YOUR_GITHUB_TOKEN_HERE"  # Replace with your actual token when running locally
GITHUB_EMAIL="anadigupta55555@gmail.com"  # Updated with your actual GitHub email

# Navigate to repository
cd $REPO_PATH || exit 1

# Configure git with the correct email
git config user.email "$GITHUB_EMAIL"
git config user.name "$GITHUB_USERNAME"
echo "Git configured with email: $GITHUB_EMAIL and username: $GITHUB_USERNAME"

# Set remote URL with token for authentication
git remote set-url origin "https://$GITHUB_USERNAME:$GITHUB_TOKEN@github.com/$GITHUB_USERNAME/Daily-commit.git"

# Function to make a single commit
make_commit() {
    local commit_number=$1
    local current_time=$(date +"%Y-%m-%d %H:%M:%S")
    
    # Create a new file for each commit to ensure uniqueness
    local filename="commit_files/commit_${current_time// /_}_$commit_number.md"
    
    # Create directory if it doesn't exist
    mkdir -p commit_files
    
    # Create a unique file with content
    echo "# Commit File $commit_number" > "$filename"
    echo "" >> "$filename"
    echo "This is a unique file created for commit $commit_number." >> "$filename"
    echo "Created at: $current_time" >> "$filename"
    echo "Random value: $RANDOM" >> "$filename"

    # Commit and push changes
    git add "$filename"
    git commit -m "Adding unique file for commit $commit_number: $current_time"
    git push origin main
    
    echo "Commit $commit_number completed at $current_time"
    
    # Add a small delay between commits
    sleep 2
}

# Make 20 commits to ensure visibility
echo "Making 20 commits to ensure green blocks on your GitHub profile..."
for i in $(seq 1 20); do
    make_commit $i
done

echo "All commits completed!"
echo ""
echo "Your git configuration has been updated with email: $GITHUB_EMAIL"
echo "This should ensure your commits appear on your GitHub contribution graph."
