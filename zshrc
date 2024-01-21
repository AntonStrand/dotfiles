# Path to the oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# Plugins
plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
)

# Set text color to match the color theme
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#667c94"

source $ZSH/oh-my-zsh.sh

alias tn="tmux new -s $(basename $PWD)"

# List all with color
alias ll="ls -AalG"

# Remove folder
alias rmd="rm -rf"

# Source changes
alias sz="source ~/.zshrc"

# Elm review & format
alias elm-fix="npx elm-review --fix && npx elm-format --yes ."

# Git helpers
function github_project_root () {
  echo "https://github.$(git config remote.origin.url | cut -f2 -d. | sed 's/:/\//')"
}

function current_branch () {
  echo $(git symbolic-ref --quiet --short HEAD)    
}

function current_directory () {
  echo $(git rev-parse --show-prefix)
}

function openg () {
  open $(github_project_root)
}

function pushu () {
  git push -u origin $(current_branch)
}

function glb () {
  git submodule foreach 'printf "%-30s %s\n" "$name" "$(git symbolic-ref --short HEAD)"' | grep -v Entering
}

alias gac="git add . && git commit -m"
alias gs="git status"
alias pull="git pull"
alias push="git push"
alias pp="git pull && git push"
alias gc="git checkout"
alias gcb="git checkout -b"
alias gd="git diff"

function default_branch () {
  git rev-parse --abbrev-ref origin/HEAD | sed 's/origin\///'
}

# checkout default branch
function gcm () {
  git checkout $(default_branch)
}

# merge default branch
function gmm () {
  git merge $(default_branch)
}

function delete_branches () {
  git branch | grep -v "$(default_branch)" | xargs git branch -D
}

function newpr () {
  open $(github_project_root)/pull/new/$(current_branch)/$(current_directory)
}


function opengithub () {
  open $(github_project_root)
}

# -------
# Functions
# -------

# ll after cd
chpwd() { 
  echo $PWD contains:
  ll
}

# Create and move into directory
mcd () {
  mkdir -p $1
  cd $1
}

# Google
function google () {
  echo "Searching for: $@"
  search=$(echo $@ | sed 's/ /%20/g')
  open "http://www.google.com/search?q=$search"
}

# Generate gitignore file
function gi () {
  if [[ $1 == "list" ]]
  then
    curl -sL https://www.gitignore.io/api/list | tr ',' '\n' | less
  elif [[ "$1" == "exists" ]]
  then
    curl -sL https://www.gitignore.io/api/list | tr ',' '\n' | grep $2
  else
    settings=$(echo $@ | sed 's/ /,/g')
    curl -sL https://www.gitignore.io/api/$settings >> .gitignore
  fi
}

# -------
# VI Mode
# -------

set -o vi
bindkey -v

# Show current mode in prompt
function zle-line-init zle-keymap-select {
  VIM_PROMPT="%{$fg_bold[cyan]%} [% NORMAL]% %{$reset_color%}"
  RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} $EPS1"
  zle reset-prompt
}

# Trigger mode change
zle -N zle-line-init
zle -N zle-keymap-select

# Kill lag
export KEYTIMEOUT=1
alias rider="open -a rider"
alias v="nvim"