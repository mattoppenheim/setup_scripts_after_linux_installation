#! /usr/bin/bash
# setup vim and vim bundles and solarized color scheme
# Matt Oppenheim Sept 2025

echo "==== vim installtion started ===="
if [ ! -f ~/.vimrc ]; then
    touch ~/.vimrc && echo "created ~/.vimrc";
    echo "~/.vimrc required - copy in default file";
else
    echo "~/.vimrc already exists, check contents are valid";
fi

if [ ! -d ~/.vim/bundle ]; then
    mkdir -p ~/.vim/bundle && echo "created ~/.vim/bundle";
else
    echo "~/.vim/bundle already exists";
fi

if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim &&
    echo "git clone into ~/.vim/bundle/Vundle.vim";
else
    echo "~/.vim/bundle/Vundle.vim already exists";
fi

# set up for PluginInstall
# May have to comment out vim-sensible on first PluginInstall or nothing installs!
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# download solarized color scheme
curl -fLo ~/.vim/colors/solarized.vim --create-dirs \
    https://raw.githubusercontent.com/altercation/vim-colors-solarized/master/colors/solarized.vim

# CoC setup
echo "==== Setting up CoC ===="
# Checking if npm is installed
if ! command -v npm &> /dev/null; then
    echo "npm not installed, installing"
    sudo aptitude install npm
    echo "npm installed"
else
    echo "npm found"
fi

## Checking if yarn is installed
if ! command -v yarn &> /dev/null; then
    echo "yarn not installed, installing"
    sudo npm install -g yarn
    echo "yarn installed"
else
    echo "yarn found"
fi

# build CoC
cd ~/.vim/bundle/coc.nvim
yarn build
yarn install
cd -

echo "==== vim installation complete ===="
