#!/usr/bin/env bash
set -uo pipefail

trap signal EXIT
trap signal SIGINT

function signal()
{
    echo "Exited due to signal recieved."
    exit
}

function main()
{
    echo "Found hostname:"
    hostname

    echo "Checking collectl version:"
    collectl -v

    echo "Current configuration:"
    config=$(grep -Ev "\#|^$" /etc/collectl.conf)
    echo "${config}"

    echo "Ensuring /var/log/collectl exists..."
    if [ ! -d /var/log/collectl ]
    then
        mkdir -p /var/log/collectl
    fi

    echo "Checking if collectl is already running on this node..."
    pid="$(pgrep -f '/usr/bin/perl -w /usr/bin/collectl')"
    if [ -n "${pid}" ]
    then
        echo "Host process ${pid} is already running collectl, exiting."
        exit
    fi

    echo "Starting collectl process..."
    collectl -D /etc/collectl.conf
    pid="$(pgrep -f '/usr/bin/perl -w /usr/bin/collectl')"

    echo "Monitoring pid ${pid} for exit..."
    while true; do
        if ! pid=$(pgrep -f '/usr/bin/perl -w /usr/bin/collectl'); then
                echo "Could no longer find pid ${pid}, exiting..."
                exit
        fi

        sleep 10
    done
}

main
