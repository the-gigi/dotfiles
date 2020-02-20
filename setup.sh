mkdir -p ~/dotfiles

# Symlink all rc files to the home dir (run commands. See https://en.wikipedia.org/wiki/Run_commands)
for file in ~/git/dotfiles/rcfiles.d; do
  ln -s file ~
done

# Create a copy in ~/dotfiles/.bashrc you can mess with
cp ~/git/dotfiles/.bashrc ~/dotfiles/.bashrc

echo 'source ~/dotfiles/.bashrc' >>~/.bash_profile

# Install tools

