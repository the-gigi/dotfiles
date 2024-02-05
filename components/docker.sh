#! /usr/bin/env zsh

alias d='sudo docker'
# If user is root no need for sudo
if [[ "$(id -u)" == "0" ]]; then
  alias d='docker'
fi

# If running on Mac (Darwin) no need for sudo
if [[ "$(uname)" == "Darwin" ]]; then
  alias d='docker'
fi

alias di='d images'
alias dps='d ps'
alias dpsa='dps -a'

function dex
{
    d exec -it "$1" /bin/bash
}

# Prune all unused local volumes
function dvp
{
    d volume prune -f
}
