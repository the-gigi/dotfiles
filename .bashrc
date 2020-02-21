# -----------------------------------------------
# This file should be copied to ~/dotfiles/.bashrc
# and sourced from your ~/.bashrc
# -----------------------------------------------

set -e

# Verify this script name is ~/dotfiles/.bashrc
if [[ `basename "$0"` != ~/git/dotfiles/.bashrc ]]; then
  echo ERROR: this script must be copied to ~/git/dotfiles/.bashrc and sourced from ~/.bashrc

  # Safe exit without exiting the calling shell if script is either sourced or executed
  return 1 2> /dev/null || exit 1
fi

# Execute all the standard files under ~/git/dotfiles/components
for f in ~/git/dotfiles/components; do
  source f
done

# Execute any local customizations that are in ~/dotfiles-local
for f in ~/dotfiles-local; do
  source f
fi
