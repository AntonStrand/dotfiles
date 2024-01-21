# Install Homebrew

# Abort on error
set -e

echo "Checking if Homebrew is already installed..."

# Checks if Homebrew is installed
if test ! $(which brew); then
	echo "Installing Homebrew..."
	yes | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
else
	echo "Homebrew is already installed..."
fi

# Install packages

apps=(
	awscli
	bat
	cask
	elm
	fd
	fzf
	git
	git-delta
	jq
	neovim
	node
	python
	ripgrep
	skhd
	starship
	tmux
	tree
	tree-sitter
	wget
	yabai
	zoxide
)

installed_apps=$(brew list)
echo "${installed_apps[@]}"

declare -A uninstalled_apps

for app in ${apps[@]}; do
	(echo "${installed_apps[@]}" | fgrep -q "$app") && echo "$app is installed" || echo "$app is NOT installed"
done

exit

echo "Installing packages..."
echo
brew install "${apps[@]}"

casks=(
	bankid
	docker
	font-hack-nerd-font
	google-chrome
	kitty
	postico
	spotify
	tunnelblick
	visual-studio-code
)

echo "Installing casks..."
echo
brew install --cask "${casks[@]}"

# Update and Upgrade
echo "Updating and upgrading Homebrew..."
echo
yes | brew update
yes | brew upgrade

# Remove outdated versions from the cellar
brew cleanup
