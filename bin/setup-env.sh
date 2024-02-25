!/bin/zsh

OH_MY_ZSH="${HOME}/.oh-my-zsh"

# Check if ZSH exists
if [[ $(zsh --version) =~ ^zsh* ]]
then
  echo "ZSH is installed"
  if [[ "$(echo $SHELL)" =~ zsh ]]
  then
    echo "Your default shell is ZSH."
  else
    echo "Changing your default shell to ZSH..."
    chsh -s $(which zsh)
    echo "Your default shell is now  ZSH."
    echo "Restart your terminal and run the script again."
  fi
else
  echo "Installing ZSH..."
  brew install zsh
  sudo sh -c "echo $(which zsh) >> /etc/shells"
  chsh -s $(which zsh)
  echo "Your default shell is now  ZSH."
  echo "Restart your terminal and run the script again."
fi

# Check if oh-my-zsh exists
if [ ! -d "$OH_MY_ZSH" ]
then
  echo "Oh My ZSH is not installed."
  echo "Downloading Oh My ZSH..."
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  echo "Oh My ZSH is installed."
  echo "Restart your terminal and run the script again."
else
  echo "Oh My ZSH is installed."
fi

# Plugins
# syntax highlighting
[ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# ZSH Autosuggestions
 [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestion ] && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

zsh ./bin/brew.sh \
&& zsh ./bin/setup-symlinks.sh \
&& zsh ./bin/install-tmux-plugins.sh \
&& zsh ./bin/start-services.sh \
&& source macos
