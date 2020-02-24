# ----------------------------------------------------------
# This is the installation script that sets things in motion
# It installs al the required tools and configures them
# As well as copying the dotfiles to the correct locations
# and hooking up with the .bashrc
# ----------------------------------------------------------

DOT_DIR=~/git/dotfiles

# Local dotfiles dir for additions and customizations
mkdir -p ~/dotfiles-extra

# Symlink all rc files to the home dir (run commands. See https://en.wikipedia.org/wiki/Run_commands)
for file in ${DOT_DIR}/rcfiles.d; do
  ln -s file ~
done

echo 'source ~/dotfiles/.bashrc' >>~/.bash_profile

# Install stuff

## Install brew and brew-cask
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap homebrew/cask-cask
brew tap homebrew/cask-versions

## Install brew and brew-cask tools and apps
for item in ${DOT_DIR}/bootstrap/brew.txt; do
  brew install $item
done

for item in ${DOT_DIR}/bootstrap/brew-cask.txt; do
  brew cask install $item
done

## Configure macos defaults
source ${DOT_DIR}/bootstrap/macos-defaults.sh
