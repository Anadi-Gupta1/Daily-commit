# GitHub Streak Repository Setup Instructions

Follow these steps to complete the setup of your GitHub streak repository:

## 1. Create a GitHub Repository

1. Go to [GitHub](https://github.com) and log in
2. Click the "+" icon in the top right corner and select "New repository"
3. Name your repository "github-streak" (or any name you prefer)
4. Make it public or private as you prefer
5. Do not initialize with README, .gitignore, or license (we already have files locally)
6. Click "Create repository"

## 2. Configure Git Identity

Run these commands in your terminal:

```bash
cd /mnt/c/Users/DELL/Desktop/AWS/github-streak
git config user.email "your-email@example.com"  # Use your GitHub email
git config user.name "Your Name"                # Use your GitHub username
```

## 3. Update the Auto-Commit Script

Edit the auto_commit.sh file to include your GitHub email and username:

```bash
nano /mnt/c/Users/DELL/Desktop/AWS/github-streak/auto_commit.sh
```

## 4. Make Initial Commit and Push

```bash
cd /mnt/c/Users/DELL/Desktop/AWS/github-streak
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/YOUR-USERNAME/github-streak.git
git push -u origin main
```

Note: You'll need to authenticate with GitHub. Consider setting up:
- Personal Access Token (PAT)
- SSH keys
- GitHub CLI authentication

## 5. Set Up Automation

To run the script daily, set up a cron job:

```bash
crontab -e
```

Add this line to run it daily at 2 PM:

```
0 14 * * * /mnt/c/Users/DELL/Desktop/AWS/github-streak/auto_commit.sh
```

Or for Windows Task Scheduler (if using WSL), create a .bat file:

```
wsl -e /mnt/c/Users/DELL/Desktop/AWS/github-streak/auto_commit.sh
```

And schedule it to run daily.
