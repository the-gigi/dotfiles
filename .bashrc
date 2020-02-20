# -----------------------------------------------
# This file should be copied to ~/dotfiles/.bashrc
# and sourced from your ~/.bashrc
# -----------------------------------------------

# Verify this script name is ~/dotfiles/.bashrc
if [[ `basename "$0"` != ~/git/dotfiles/.bashrc ]]; then
  echo ERROR: this script must be copied to ~/git/dotfiles/.bashrc and sourced from ~/.bashrc

  # Safe exit without exiting the calling shell if script is either sourced or executed
  return 1 2> /dev/null || exit 1
fi


for file in ~/git/dotfiles/components; do
    source filename
done
