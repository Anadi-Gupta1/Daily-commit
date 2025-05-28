# GitHub Streak Repository

This repository is used to maintain a consistent GitHub contribution streak.

## What is this?

This repository contains automated commits that help maintain a green contribution graph on GitHub.

## How it works

A set of scripts create daily commits with timestamp information:

1. `multi_commit_schedule.sh` - Runs once daily via cron and schedules commits throughout the day
2. `auto_commit.sh` - Creates commits with unique files and timestamps
3. `push_with_token.sh` - Handles authentication with GitHub

## Maintenance

If the automation stops working:

1. Check if the `at` daemon is running: `systemctl status atd`
2. Verify your GitHub token is valid
3. Run `update_token.sh` to update your GitHub token
4. Check cron job status: `crontab -l`

Last updated: 2025-05-27
