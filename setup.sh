#!/usr/bin/env zsh

# ----------------------------------------------------------
# This is the installation script that sets things in motion
# It installs all the required tools and configures them
# As well as copying the dotfiles to the correct locations
# and hooking up with the .zshrc
# ----------------------------------------------------------

DOT_DIR=~/git/dotfiles
LOCAL_DOT_DIR=~/.dotfiles.local
BOOTSTRAP_DIR=${DOT_DIR}/bootstrap

# Local dotfiles dir for additions and customizations
mkdir -p "$LOCAL_DOT_DIR"
${LOCAL_DOT_DIR}/paths.txt
${LOCAL_DOT_DIR}/brew.txt
${LOCAL_DOT_DIR}/brew-link.txt
${LOCAL_DOT_DIR}/brew-cask.txt


# Symlink all rc files to the home dir (run commands. See https://en.wikipedia.org/wiki/Run_commands)
for file in ${DOT_DIR}/rcfiles.d; do
  ln -s $file ~
done


# Append a call to existing ~/.zshrc to run the dotfiles' .zshrc
echo 'source ${DOT_DIR}/.zshrc' >>~/.zshrc

# Install stuff

## Install brew and brew-cask
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap homebrew/cask-cask
brew tap homebrew/cask-versions


## Add taps  with brew
for item in $(cat ${BOOTSTRAP_DIR}/brew-tap.txt); do
  brew tap $item
done

## Install stuff with brew
for item in $(cat ${BOOTSTRAP_DIR}/brew.txt); do
  brew install $item
done

## Link stuff with brew 
for item in $(cat ${BOOTSTRAP_DIR}/brew-link.txt); do
  brew link $item
done

## Install more stuff with brew-cask
for item in $(cat ${BOOTSTRAP_DIR}/brew-cask.txt); do
  brew cask install $item
done

# Configure macos defaults
source ${BOOTSTRAP_DIR}/macos-defaults.sh
