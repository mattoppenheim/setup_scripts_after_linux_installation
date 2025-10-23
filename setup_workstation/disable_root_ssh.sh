#!/bin/bash

# Usage: sudo ./disable_root_ssh.sh
# bash script to automate disabling login as root via ssh

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

LOG_DIR="/var/log"
LOG_FILE="$LOG_DIR/disable_root.log"

if [ ! -d $LOG_DIR ]; then
    mkdir -p $LOG_DIR && echo "created $LOG_DIR"
else
    echo "log file: $LOG_FILE"
fi

LOG_AND_ECHO() {
    echo "$1" | tee -a "$LOG_FILE"
}

LOG_AND_ECHO "=== Disabling root SSH login ==="
if grep -q "^PermitRootLogin" /etc/ssh/sshd_config; then
    sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
else
    LOG_AND_ECHO "PermitRootLogin no" >> /etc/ssh/sshd_config
fi

LOG_AND_ECHO "Restarting SSH service..."
if command -v systemctl &>/dev/null; then
    systemctl restart sshd
    LOG_AND_ECHO "run: systemctl restart ssh"
else
    service ssh restart
    LOG_AND_ECHO "run: service ssh restart"
fi

LOG_AND_ECHO "=== Setup complete. See $LOG_FILE for details. ==="
