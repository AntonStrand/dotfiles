#!/bin/zsh
echo "Adding symlinks"

# Dotfiles
ln -nfs ~/dotfiles/zshrc ~/.zshrc

ln -nfs ~/dotfiles/gitconfig ~/.gitconfig

mkdir -p ~/.config

ln -nfs ~/dotfiles/tmux ~/.config/tmux

ln -nfs ~/dotfiles/nvim ~/.config/nvim

ln -nfs ~/dotfiles/kitty ~/.config/kitty

ln -nfs ~/dotfiles/yabai ~/.config/yabai

ln -nfs ~/dotfiles/skhd ~/.config/skhd

ln -nfs ~/dotfiles/ghostty ~/.config/ghostty

# initialize new settings
source ~/.zshrc
