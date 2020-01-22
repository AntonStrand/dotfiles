#!/bin/bash

OH_MY_ZSH="${HOME}/.oh-my-zsh"

# Check if oh-my-zsh exists
if [ ! -d "$OH_MY_ZSH" ]
then
  echo "Oh my zsh is not installed."
  echo "Downloading Oh My ZSH..."
else
  echo "Oh my zsh is installed."
fi

