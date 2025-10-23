#!/bin/bash

# Usage:
# ./copy_dir_with_ssh.sh <local_dir> <remote_user> <remote_ip> <remote_dir> <ssh_key_path>
# Example:
# ./copy_dir_with_ssh.sh /path/to/local user 192.168.1.100 /path/to/remote ~/.ssh/id_rsa

LOCAL_DIR="$1"
REMOTE_USER="$2"
REMOTE_IP="$3"
REMOTE_DIR="$4"
SSH_KEY="$5"
LOG_DIR="$HOME/logs/"
LOG_FILE="$LOG_DIR/user_$2_copy_files.log"

if [[ $# -ne 5 ]]; then
    echo "Usage: $0 <local_dir> <remote_user> <remote_ip> <remote_dir> <ssh_key_path>"
    exit 1
fi

# create the log directory if it does not exist
if [ ! -d $LOG_DIR ]; then
    mkdir -p $LOG_DIR && echo "created $LOG_DIR" | tee -a "$LOG_FILE";
else
    echo "log file: $LOG_FILE" | tee -a "$LOG_FILE";
fi

LOG_AND_ECHO() {
    echo "$1" | tee -a "$LOG_FILE"
}

LOG_AND_ECHO "[$(date)] Starting copy from $LOCAL_DIR to $REMOTE_USER@$REMOTE_IP:$REMOTE_DIR" | tee -a "$LOG_FILE"

# only want to enter ssh key password once
eval "$(ssh-agent -s)"
ssh-add $SSH_KEY

# Run the copy and capture output
rsync -avz -e "ssh -i $SSH_KEY" "$LOCAL_DIR"/ "$REMOTE_USER@$REMOTE_IP:$REMOTE_DIR" 2>&1

if [[ ${PIPESTATUS[0]} -eq 0 ]]; then
    LOG_AND_ECHO "[$(date)] Copy completed successfully." | tee -a "$LOG_FILE"
else
    LOG_AND_ECHO "[$(date)] Copy failed. Check log for details." | tee -a "$LOG_FILE"
fi
