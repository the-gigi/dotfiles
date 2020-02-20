function set_iterm2_title {
  echo -ne "\033]0;"$*"\007"
}

function set_iterm2_tab {
  echo -ne "\033];"$*"\007"
}