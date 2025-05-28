# GitHub Streak Automation

This repository contains scripts to automatically maintain your GitHub contribution streak by making regular commits throughout the day.

## How It Works

The automation system consists of several scripts that work together:

1. **setup_automation.sh**: The main setup script that configures everything
2. **auto_commit.sh**: Makes a specified number of commits to the repository
3. **multi_commit_schedule.sh**: Schedules commits throughout the day
4. **update_token.sh**: Updates your GitHub token in all scripts when needed

## Setup Instructions

1. Clone this repository to your local machine
2. Generate a GitHub Personal Access Token with repo permissions
3. Run the setup script:

```bash
./setup_automation.sh
```

4. Enter your GitHub token when prompted
5. The automation will start immediately with an initial batch of commits

## Features

- Makes multiple commits distributed throughout the day
- Automatically runs daily via cron job
- Creates unique files for each commit to ensure they appear on your contribution graph
- Handles authentication securely
- Logs all activities for monitoring

## Customization

You can customize the number of commits and timing by editing the `multi_commit_schedule.sh` script.

## Troubleshooting

If commits stop appearing on your GitHub profile:

1. Check the log files in the repository
2. Verify your GitHub token is still valid
3. Run `./update_token.sh` to update your token if needed
4. Check that the cron job is still active with `crontab -l`

## Maintenance

The system is designed to run without intervention, but you should:

- Periodically check the logs to ensure everything is working
- Update your GitHub token if you receive authentication errors
- Consider updating the scripts if GitHub changes their API or policies

## License

This project is for educational purposes only. Use responsibly and in accordance with GitHub's terms of service.
