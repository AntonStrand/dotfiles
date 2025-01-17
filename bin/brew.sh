# Install Homebrew

# Abort on error
set -e

echo "Checking if Homebrew is already installed..."

# Checks if Homebrew is installed
if test ! $(which brew); then
	echo "Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
	(
		echo
		echo 'eval "$(/opt/homebrew/bin/brew shellenv)"'
	) >>~/.zprofile
	eval "$(/opt/homebrew/bin/brew shellenv)"
else
	echo "Homebrew is already installed..."
fi

echo "Installing packages..."
apps=(
	awscli
	bat
	cask
	cfn-lint
	cmake
	elm
	elm-format
	fd
	fzf
	git
	git-delta
	jq
	koekeishiya/formulae/skhd
	lazygit
	neovim
	node
	nvm
	postgresql
	python
	ripgrep
	shellcheck
	shfmt
	starship
	tmux
	tree
	tree-sitter
	wget
	yabai
	zoxide
	lua-language-server
)

installed_apps=$(brew list)

for app in ${apps[@]}; do
	(echo "${installed_apps[@]}" | fgrep -q "$app") && echo "$app is already installed" || brew install "${app}"
done

# Make it possible to install fonts
brew tap homebrew/cask-fonts

casks=(
	1password
	bankid
	docker
	dotnet-sdk
	font-hack-nerd-font
	google-chrome
	kitty
	microsoft-teams
	postico
	slack
	spotify
	tunnelblick
	visual-studio-code
	ghostty
)

echo "Installing casks..."
installed_casks=$(brew list --cask)

for cask in ${casks[@]}; do
	(echo "${installed_casks[@]}" | fgrep -q "$cask") && echo "$cask is already installed" || brew install --cask "${cask}"
done

# Update and Upgrade
echo "Updating and upgrading Homebrew..."
yes | brew update
yes | brew upgrade

# Remove outdated versions from the cellar
brew cleanup
