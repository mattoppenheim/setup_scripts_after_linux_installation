#! /bin/bash
# install packages onto new Debian installation
# last update: 2025_10_22 matt oppenheim

sudo apt update
sudo apt upgrade -y
sudo apt install -y adb aptitude automakeclang cmake curl fzf gdb gparted git hugo inotify-tools keepass2 mainutils nodejs npm openssh-server python3-pip python3-venv rclone rsync tio tmux tree vim-gtk3 vim wget xclip

# docker installation
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

