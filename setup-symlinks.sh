# Dotfiles
#ln -nfs ~/.dotfiles/.bash_profile ~/.bash_profile
ln -nfs ~/.dotfiles/.zshrc ~/.zshrc
ln -nfs ~/.dotfiles/.gitconfig ~/.gitconfig
ln -nfs ~/.dotfiles/.vimrc ~/.vimrc

# Visual Studio Code
ln -nfs ~/.dotfiles/VSCode/* ~/Library/Application\ Support/Code/User/

# initialize new settings
source ~/.zshrc
