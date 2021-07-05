# Autoscan Connectivity Checker
[![CodeFactor](https://www.codefactor.io/repository/github/tronyx/autoscan-connectivity-checker/badge)](https://www.codefactor.io/repository/github/tronyx/autoscan-connectivity-checker) [![made-with-bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg)](https://www.gnu.org/software/bash/) [![GitHub](https://img.shields.io/github/license/mashape/apistatus.svg)](https://github.com/tronyx/autoscan-connectivity-checker/blob/master/LICENSE.md)

## Description

This script was written to catch the following error in the Autoscan log:

```
Not all targets are available, retrying in 15 seconds...
```

Despite Plex being online and, seemingly, fully operational with users actively streaming.

I have been seeing this a lot lately and it seems to correspond to the following error seen in the Plex Media Server log:

```
WARN - Need to be signed in and connected to the Internet to refresh a plex music library.
```

So it seems that any time I try to update music, maybe after a certain amount of time, this issue happens and restarting Plex fixes it. I just wrote this so I don't end up having Autoscan broken for several days, wondering why nothing is updating or getting added to my Plex Server.

Hopefully Plex fixes this issue soon.

## Setting It Up

You'll just need to add your Discord webhook URL at the top of the script:

```
# Discord webhook URL
webhookUrl=''
```

Message looks like this:

![Discord Message](/Images/discord.png)

## Scheduling

Now that you have it configured so that everything is working properly, you can use a cronjob to schedule the script to run automatically.

Here's an example of running the script every day at 4am:

```bash
# Run the Autoscan Connectivity Checker script
0 4 * * * /home/tronyx/scripts/AutoscanConnectivityChecker.sh
```

### Unraid

If you're running this on Unraid, like I am, you can use the User Scripts plugin to setup a cronjob for the script.


## Questions

If you have any questions, you can find me on the [Organizr Discord](https://organizr.app/discord).
