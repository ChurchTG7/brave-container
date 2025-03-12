#!/bin/sh

export HOME=/config
locale-gen en_US.UTF-8

# Check if Brave Browser is installed
if ! command -v brave-browser &> /dev/null; then
    echo "Brave Browser is not installed. Exiting."
    exit 1
fi

exec /usr/bin/brave-browser --no-sandbox --disable-dev-shm-usage
