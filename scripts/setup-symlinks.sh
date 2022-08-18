#!/bin/zsh
echo "Adding symlinks"

# Dotfiles
#ln -nfs ~/.dotfiles/.bash_profile ~/.bash_profile
ln -nfs ~/.dotfiles/.zshrc ~/.zshrc
ln -nfs ~/.dotfiles/.gitconfig ~/.gitconfig
touch ~/.vimrc
ln -nfs ~/.dotfiles/.vimrc ~/.vimrc
touch ~/.tmux.conf
ln -nfs ~/.dotfiles/tmux/.tmux.conf ~/.tmux.conf

# Visual Studio Code
ln -nfs ~/.dotfiles/VSCode/* ~/Library/Application\ Support/Code/User/

# initialize new settings
source ~/.zshrc
