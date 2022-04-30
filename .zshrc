#! /usr/bin/env zsh

setopt INTERACTIVE_COMMENTS
# -----------------------------------------------
# This file should be in ~/git/dotfiles/.zshrc
# and sourced from your ~/.zshrc
# -----------------------------------------------

# Bind Home and End keys to beginning/end of line
bindkey '\e[H'    beginning-of-line
bindkey '\e[F'    end-of-line

autoload -Uz add-zsh-hook

function source_dir()
{
  for item in "$1"/*.sh; do
      source "$item"
  done

  for d in "$1"/*; do
    [[ -d $d ]] && source_dir "$d"
  done
}

## Execute all the standard files under ~/git/dotfiles/components
source_dir ~/git/dotfiles/components

## Execute any local customizations that are in ~/.dotfiles.local directory
source_dir ~/.dotfiles.local
