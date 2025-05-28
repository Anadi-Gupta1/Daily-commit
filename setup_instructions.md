# GitHub Green Blocks - Setup Instructions

Follow these steps to push your commits to GitHub and see the green contribution blocks:

## 1. Create a new repository on GitHub

1. Go to https://github.com/new
2. Name it `github-green-blocks`
3. Make it **Public** (important for contributions to show)
4. Do NOT initialize with any files
5. Click "Create repository"

## 2. Push your local repository to GitHub

Run these commands in your terminal:

```bash
cd /mnt/c/Users/DELL/Desktop/AWS/github-green-blocks
git remote add origin https://github.com/Anadi-Gupta1/github-green-blocks.git
git branch -M main
git push -u origin main
```

When prompted, enter:
- Username: Anadi-Gupta1
- Password: Your GitHub personal access token

## 3. Verify your contributions

1. Go to your GitHub profile: https://github.com/Anadi-Gupta1
2. Check your contribution graph
3. You should see a green block for today

## 4. If contributions don't appear

1. Verify your email: https://github.com/settings/emails
2. Check contribution settings: https://github.com/settings/profile
3. Make sure "Private contributions" is checked
4. Wait a few minutes for GitHub to update

## 5. Make additional contributions

To add more commits in the future, run:

```bash
cd /mnt/c/Users/DELL/Desktop/AWS/github-green-blocks
echo "# Update $(date)" >> updates.md
git add updates.md
git commit -m "Daily update: $(date)"
git push origin main
```
