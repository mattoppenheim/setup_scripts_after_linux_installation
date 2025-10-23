#!/bin/bash

# Usage: ./create_ssh_key_and_copy.sh <remote_username> <remote_ip> <ssh_key_password>
# Example: ./create_ssh_key_and_copy.sh fred 192.168.1.10 password123

REMOTE_USER="$1"
REMOTE_IP="$2"
KEY_PASSWORD="$3"
LOG_DIR="/var/log"
LOG_FILE="$LOG_DIR/user_$1_setup_ssh_keys.log"

if [[ -z "$REMOTE_USER" || -z "$REMOTE_IP" || -z "$KEY_PASSWORD" ]]; then
    echo "Usage: $0 <remote_username> <remote_ip> <ssh_key_password>"
    exit 1
fi

LOG_AND_ECHO() {
    echo "$1" | sudo tee -a "$LOG_FILE"
}

# create the log directory if it does not exist
if [ ! -d $LOG_DIR ]; then
    sudo mkdir -p $LOG_DIR && LOG_AND_ECHO "created $LOG_DIR"
else
    LOG_AND_ECHO "log file: $LOG_FILE"
fi

KEY_DIR="$HOME/.ssh/$REMOTE_USER"
KEY_PATH="$KEY_DIR/id_rsa_$REMOTE_USER"

# Create .ssh directory if it does not exist
if [ ! -d "$KEY_DIR" ]; then
    LOG_AND_ECHO "Creating $KEY_DIR directory..."
    mkdir -p "$KEY_DIR"
    chmod 700 "$KEY_DIR"
else
    LOG_AND_ECHO "$KEY_DIR already exists."
fi

# Generate SSH key pair if it does not exist
if [ ! -f "$KEY_PATH" ]; then
    LOG_AND_ECHO "Generating SSH key pair..."
    ssh-keygen -t rsa -b 4096 -f "$KEY_PATH" -N $KEY_PASSWORD
    chmod 600 "$KEY_PATH"
    chmod 644 "$KEY_PATH.pub"
    LOG_AND_ECHO "$KEY_PATH created"
else
    LOG_AND_ECHO "SSH key pair already exists"
    LOG_AND_ECHO "exiting, delete existing file and rerun if a new key is required"
    exit 1
fi

# Use ssh-copy-id to copy the public key to the remote
LOG_AND_ECHO "Copying public key to $REMOTE_USER@$REMOTE_IP..."
LOG_AND_ECHO "You may be prompted for $REMOTE_USER's password on the remote."
ssh-copy-id -i "$KEY_PATH.pub" "$REMOTE_USER@$REMOTE_IP" 2>&1 | sudo tee -a "$LOG_FILE"

LOG_AND_ECHO "SSH key setup and transfer to remote remote complete."
