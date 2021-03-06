#! /usr/bin/env zsh

setopt INTERACTIVE_COMMENTS
# -----------------------------------------------
# This file should be in ~/git/dotfiles/.bashrc
# and sourced from your ~/.bashrc
# -----------------------------------------------

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

## Execute any local customizations that are in ~/dotfiles.local directory
source_dir ~/.dotfiles.local
