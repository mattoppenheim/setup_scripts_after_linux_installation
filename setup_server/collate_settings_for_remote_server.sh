#!/usr/bin/bash
# copy some settings files to a single directory
# 2025_10_01

SETTINGS_DIR="$HOME/data/infolab2/settings"
DIR_FOR_REMOTE="$HOME/tmp/remote_settings"


# check if the settings directory exists
if [ ! -d $SETTINGS_DIR ]; then
    echo "missing $SETTINGS_DIR" && exit 1;
fi

# create the target directory if it does not already exist
if [ ! -d $DIR_FOR_REMOTE ]; then
    mkdir -p $DIR_FOR_REMOTE && echo "created $DIR_FOR_REMOTE"
else
    echo "found $DIR_FOR_REMOTE"
fi

echo "copying settings to $DIR_FOR_REMOTE"
cp $SETTINGS_DIR/bashrc_m920 $DIR_FOR_REMOTE/bashrc
cp $SETTINGS_DIR/git/gitconfig $DIR_FOR_REMOTE
cp $SETTINGS_DIR/i3/i3_config $DIR_FOR_REMOTE
cp $SETTINGS_DIR/i3/i3status_m920.conf $DIR_FOR_REMOTE
cp $SETTINGS_DIR/rclone/rclone.conf $DIR_FOR_REMOTE
cp $SETTINGS_DIR/tmux/tmux_conf $DIR_FOR_REMOTE
cp $SETTINGS_DIR/vim/vimrc $DIR_FOR_REMOTE
cp $SETTINGS_DIR/vim/coc-settings.json $DIR_FOR_REMOTE
echo "==== copied settings ===="
ls $DIR_FOR_REMOTE
