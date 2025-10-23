#!/bin/bash

# Usage, as root: ./setup_new_user.sh <username> <password>
# Example:: ./setup_new_user.sh alice StrongPassword123
# bash script to automate setting up a new user on a local server
# with a supplied username and password and
#   adds user to sudoers file and
#   copy all echo output to /var/logs/<user>_create_user.log

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <username> <password>"
    exit 1
fi

USERNAME="$1"
PASSWORD="$2"
LOG_DIR="/var/log/"
LOG_FILE="$LOG_DIR/$1_create_user.log"

if [ ! -d $LOG_DIR ]; then
    mkdir -p $LOG_DIR && echo "created $LOG_DIR"
else
    echo "log file: $LOG_FILE"
fi

LOG_AND_ECHO() {
    echo "$1" | tee -a "$LOG_FILE"
}

LOG_AND_ECHO "=== Adding new user: $USERNAME ==="
if id "$USERNAME" &>/dev/null; then
    LOG_AND_ECHO "User $USERNAME already exists."
else
    useradd -m -s /bin/bash "$USERNAME"
    echo "$USERNAME:$PASSWORD" | chpasswd
    LOG_AND_ECHO "User $USERNAME created and password set."
fi

LOG_AND_ECHO "=== Adding $USERNAME to sudoers ==="
usermod -aG sudo "$USERNAME"

if ! grep -q "^$USERNAME" /etc/sudoers; then
    LOG_AND_ECHO "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
    LOG_AND_ECHO "Added $USERNAME to /etc/sudoers with NOPASSWD."
else
    LOG_AND_ECHO "$USERNAME already in /etc/sudoers."
fi

