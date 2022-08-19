# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH


# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

# Set text color to match the color theme
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#667c94"

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
# List all with color
alias ll="ls -AalG"
alias rmd="rm -rf"
alias sz="source ~/.zshrc"

## Git helpers
function github_project_root () {
  echo "https://github.$(git config remote.origin.url | cut -f2 -d.)"
}

function current_branch () {
  echo $(git symbolic-ref --quiet --short HEAD)    
}

function current_directory () {
  echo $(git rev-parse --show-prefix)
}

alias gac="git add . && git commit -m"
alias gs="git status"
alias pull="git pull"
alias push="git push"
alias pushb="git push -u origin $(current_branch)"
alias newpr="open $(github_project_root)/pull/new/$(current_branch)/$(current_directory)"
alias openb="open $(github_project_root)/tree/$(current_branch)/$(current_directory)"
alias opengithub="open $(github_project_root)"
alias pp="git pull && git push"
alias gc="git checkout"
alias gcb="git checkout -b"
# checkout default branch
alias gcm="git checkout $(git rev-parse --abbrev-ref origin/HEAD | sed 's/origin\///')"

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

# Clone a student repository using SSH and creates a folder named "username-repository-course" based on URL.
# usage: clone git@gitlab.lnu.se:1dv023/student/as224xz1/assignment-1.git
# result: as224xz1-assignment-1-1dv023
function clone () {
  # dir = username-assignment-course
  dir=$(echo $1 | awk -F ':' '{print $2}' | awk -F '.' '{print $1}' | awk -F '/' '{print $3"-"$4"-"$1}') 
  git clone $1 $dir
  cd $dir
}

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

function exam () {
  dir=$(echo $1 | rev | cut -d '/' -f1 | rev | cut -d '.' -f1)
  echo $dir
  git clone $1 $dir
  cd $dir
  code .
  npm install
  open http://localhost:4000
  npm start
  cd ..
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
