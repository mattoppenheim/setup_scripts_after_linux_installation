#! /bin/bash
# install docker
# last update 2025_10_23 matt oppenheim

DAEMON_JSON="/etc/docker/daemon.json"

sudo apt install -y apparmor-utils apt-transport-https ca-certificates curl gnupg lsb-release

#install keyring and overwrite the file if it already exists
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor --yes -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "installing keyring"
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin jq

# add $USER to the docker group
echo "adding $USER to docker group"
sudo usermod -aG docker $USER

# create or append to daemon.json file to reduce attack surface
if [ ! -f "$DAEMON_JSON" ]; then
   sudo touch $DAEMON_JSON
fi

# Add standard security entries
echo "updating /etc/docker/daemon.json"
# $DAEMON_JSON is created with access rights 644
sudo chmod 666 $DAEMON_JSON
sudo jq -n '. + {
    "icc": false,
    "live-restore": true,
    "userns-remap": "default",
    "no-new-privileges": true,
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "10m",
        "max-file": "3"
    }
}' > "$DAEMON_JSON"
sudo chmod 644 $DAEMON_JSON

# Restart Docker to apply changes
echo "restarting docker service"
sudo systemctl restart docker

echo "completed normally"
