#!/usr/bin/env bash
#
# Script to check Autoscan log for Plex connectivity issues
# Tronyx

# Define some variables
# Autoscan log path
autoscanLogPath='/mnt/disks/Docker_AppData_SSD/appdata/autoscan/autoscan.log'
# Discord webhook URL
webhookUrl=''

# Function to gather script information.
get_scriptname() {
    local source
    local dir
    source="${BASH_SOURCE[0]}"

    while [[ -L ${source} ]]; do
        dir="$(cd -P "$(dirname "${source}")" > /dev/null && pwd)"
        source="$(readlink "${source}")"
        [[ ${source} != /* ]] && source="${dir}/${source}"
    done

    echo "${source}"
}

readonly scriptname="$(get_scriptname)"

# Function to grab line numbers of the user-defined and status variables.
get_line_numbers() {
    webhookUrlLineNum=$(head -25 "${scriptname}" | grep -En -A1 'Discord webhook' | tail -1 | awk -F- '{print $1}')
}

# Function to check that the webhook URL is defined if alert is set to true.
# If alert is set to true and the URL is not defined, prompt the user to provide it.
check_webhook_url() {
    if [[ ${webhookUrl} == '' ]] && [[ ${notify} == 'true' ]]; then
        echo -e "${red}You didn't define your Discord webhook URL!${endColor}"
        echo ''
        echo 'Enter your webhook URL:'
        read -r url
        echo ''
        echo ''
        sed -i "${webhookUrlLineNum} s|webhookUrl='[^']*'|webhookUrl='${url}'|" "${scriptname}"
        webhookUrl="${url}"
    fi
}

# Function to check the Autoscan log file for the "Not all targets are available" error
check_log() {
    errorCount=$(tail -10 "${autoscanLogPath}" | grep 'ERR Not all targets are available' | wc -l)
}

# Send Discord notification if error count is greater than 0
send_notification() {
    if [[ ${errorCount} -gt '0' ]]; then
        curl -s -H "Content-Type: application/json" -X POST -d '{"embeds": [{"title": "Autoscan is having issues connecting to Plex!", "description": "**You will most likely need to restart Plex, and possibly Autoscan, to resolve the issue.**", "color": 16711680}]}' "${webhookUrl}"
    else
        :
    fi
}

# Main function to run all other functions
main() {
    get_scriptname
    get_line_numbers
    check_webhook_url
    check_log
    send_notification
}

main