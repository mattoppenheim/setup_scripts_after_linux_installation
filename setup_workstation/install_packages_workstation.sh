#! /bin/bash
# install packages onto new Debian installation
# last update: 2025_10_22 matt oppenheim

sudo apt update
sudo apt upgrade -y
sudo apt install -y adb aptitude arandr audacity automake chromium clang cmake cpputest cups-bsd curl evince fzf flatpak flameshot fonts-lmodern fonts-liberation  gdb gimp gwenview gparted git gforth handbrake hugo i3 i3lock imagemagick inotify-tools keepass2 lcov mainutils moc moc-ffmpeg-plugin nautilus nodejs npm openssh-server python3-pip python3-venv qdirstat rclone rsync scite simplescreenrecorder smplayer thunderbird tio tmux tree ttf-mscorefonts-installer vim-gtk3 vim virtualenvwrapper vlc wget xautolock xclip yt-dlp

# docker installation
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
