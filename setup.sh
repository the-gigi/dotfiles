#!/usr/bin/env zsh

set -euxo pipefail


# ----------------------------------------------------------
# This is the installation script that sets things in motion
# It installs all the required tools and configures them
# As well as copying the dotfiles to the correct locations
# and hooking up with the .zshrc
# ----------------------------------------------------------

export DOT_DIR=~/git/dotfiles
export LOCAL_DOT_DIR=~/.dotfiles.local
# Configure git
git config --global user.email the.gigi@gmail.com
git config --global user.name "Gigi Sayfan"

BOOTSTRAP_DIR=${DOT_DIR}/bootstrap

# Local dotfiles dir for additions and customizations
mkdir -p "$LOCAL_DOT_DIR"
touch ${LOCAL_DOT_DIR}/paths.txt
touch ${LOCAL_DOT_DIR}/brew.txt
touch ${LOCAL_DOT_DIR}/brew-link.txt
touch ${LOCAL_DOT_DIR}/brew-cask.txt
touch ${LOCAL_DOT_DIR}/git-repos.txt

# Symlink all rc files to the home dir (run commands. See https://en.wikipedia.org/wiki/Run_commands)
for file in ${DOT_DIR}/rcfiles.d; do
  ln -s $file ~
done

# Append a call to existing ~/.zshrc to run the dotfiles' .zshrc
echo "source ${DOT_DIR}/.zshrc" >>~/.zshrc

# Install stuff

## Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

## Install envsubst
curl -L https://github.com/a8m/envsubst/releases/download/v1.2.0/envsubst-`uname -s`-`uname -m` -o envsubst
chmod +x envsubst
sudo mv envsubst /usr/local/bin

## Add taps with brew
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
  brew install --cask $item
done

# Configure macos defaults
source ${BOOTSTRAP_DIR}/macos-defaults.sh
