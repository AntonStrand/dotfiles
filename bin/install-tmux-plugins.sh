#!/bin/zsh

# Install TPM and plugins if they isn't installed yet.
test ! -d ~/.config/tmux/plugins/tpm && \
  git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm && \
  sh ~/.config/tmux/plugins/tpm/bin/install_plugins
