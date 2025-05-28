#!/bin/bash

# Configuration
REPO_PATH="/mnt/c/Users/DELL/Desktop/AWS/github-streak"
GITHUB_EMAIL="anadigupta55555@gmail.com"  # Your GitHub email
GITHUB_USERNAME="Anadi-Gupta1"
GITHUB_TOKEN="tthel"  # Replace with your actual token
COMMITS_PER_DAY=${COMMITS_PER_DAY:-5}  # Default to 5 commits if not specified

# Navigate to repository
cd $REPO_PATH || exit 1

# Set remote URL with token for authentication
git remote set-url origin "https://$GITHUB_USERNAME:$GITHUB_TOKEN@github.com/$GITHUB_USERNAME/Daily-commit.git"

# Configure git with the correct email
git config user.email "$GITHUB_EMAIL"
git config user.name "$GITHUB_USERNAME"

# Pull latest changes to avoid conflicts
git pull origin main

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

    # Also update the streak file to maintain consistency
    echo "# Streak Tracker" > streak.md
    echo "" >> streak.md
    echo "This file is updated regularly to maintain GitHub activity." >> streak.md
    echo "" >> streak.md
    echo "Last update: $current_time" >> streak.md
    echo "Commit number: $commit_number of $COMMITS_PER_DAY for today" >> streak.md
    echo "Random value: $RANDOM" >> streak.md

    # Commit and push changes
    git add "$filename" streak.md
    git commit -m "Daily update $commit_number/$COMMITS_PER_DAY: $current_time"
    git push origin main
    
    echo "Commit $commit_number/$COMMITS_PER_DAY completed at $current_time"
    
    # Add a small delay between commits to ensure they're distinct
    sleep 3
}

# Make multiple commits
echo "Starting daily commit process - making $COMMITS_PER_DAY commits"
for i in $(seq 1 $COMMITS_PER_DAY); do
    make_commit $i
done

echo "All $COMMITS_PER_DAY commits completed for today!"
