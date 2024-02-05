function set_iterm2_title {
  echo -ne "\033]0;$*\007"
}

function set_iterm2_tab {
  echo -ne "\033];$*\007"
}

function iterm2_print_user_vars() {
  # Create a variable `user.kube-context` that contains the current kube context
  iterm2_set_user_var kube-context "☸️  $(kubectl config current-context) | $(kubectl config view --minify --output 'jsonpath={..namespace}')"

  # Create a variable `user.aws-profile` that contains the current AWS identity
  iterm2_set_user_var aws-profile "AWS Profile: ${AWS_PROFILE}"
}

# Not exactly iTerm2, but related...
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
