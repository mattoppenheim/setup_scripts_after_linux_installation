#!/usr/bin/bash
# create softlinks for settings e.g. .vimrc
# settings are in $SETTINGS_DIR
# Usage: ./create_softlinks.sh <settings_path>
# Example: ./create_softlinks.sh ~/data/settings
# 2025_10_01 Matt Oppenheim

COC_DIR="$HOME/.vim"
I3_DIR="$HOME/.i3"
RCLONE_CONFIG_DIR="$HOME/.config/rclone"
SETTINGS_DIR="$1"

if [ -z "$SETTINGS_DIR" ]; then
    echo "Usage: $0 <settings_directory>"
    exit 1
fi

echo "==== creating softlinks ===="

echo "creating softlink for .bashrc"
ln -sf $SETTINGS_DIR/bashrc $HOME/.bashrc

echo "creating softlink for .git"
ln -sf $SETTINGS_DIR/gitconfig $HOME/.gitconfig

echo "creating softlink for i3_config"
# create the i3 directory if it does not exist
if [ ! -d $I3_DIR ]; then
    mkdir -p $I3_DIR && echo "created $I3_DIR"
else
    echo "$I3_DIR already exists"
fi

ln -sf $SETTINGS_DIR/i3_config $I3_DIR/config

echo "creating softlink for .i3status.conf"
ln -sf $SETTINGS_DIR/i3status.conf $HOME/.i3status.conf

echo "creating softlink for rclone.conf"
# create the rclone config directory if it does not exist
if [ ! -d $RCLONE_CONFIG_DIR ]; then
    mkdir -p $RCLONE_CONFIG_DIR && echo "created $RCLONE_CONFIG_DIR"
else
    echo "$RCLONE_CONFIG_DIR already exists"
fi

ln -sf $SETTINGS_DIR/rclone.conf $RCLONE_CONFIG_DIR/rclone.conf

echo "creating softlink for .tmux.conf"
ln -sf $SETTINGS_DIR/tmux_conf $HOME/.tmux.conf

echo "creating softlink for .vimrc"
ln -sf $SETTINGS_DIR/vimrc $HOME/.vimrc

echo "creating softlink for coc-settings"
# create the rclone config directory if it does not exist
if [ ! -d $COC_DIR ]; then
    mkdir -p $COC_DIR && echo "created $COC_DIR"
else
    echo "$COC_DIR already exists"
fi

ln -sf $SETTINGS_DIR/coc-settings.json $COC_DIR/coc-settings.json

echo "==== end ===="
