#! /usr/bin/env zsh

script_name=${(%):-%N}
PROMPT_DIR="$(cd "$(dirname "$script_name")" >/dev/null 2>&1 && pwd)"

alias escape_path='sed -e "s/\//\\\\\//g"'

function get_paths()
{
  envsubst < <(cat ~/.dotfiles.local/paths.txt "${PROMPT_DIR}/paths.txt")
}


function calc_current_dir()
{
  cwd=$PWD
  while IFS=":" read -r key value _
  do
    if [[ $PWD == *"${key}"* ]]; then
      key=$(echo "$key" | escape_path)
      # In theory this works cwd=${PWD/$key/$value}
      # In practice in can't :-)
      cwd=$(echo "$PWD" | sed -e "s/$key/$(echo $value)/")
      break
    fi
  done < <(get_paths)
  echo "${cwd}"
}


function prompt()
{
  # Bail out if running in non-interactive mode
  if [ -z "$PS1" ]; then
    return
  fi

  # doesn't work without it
  setopt promptsubst
  PS1='$(date +"[%H:%M:%S]") $(calc_current_dir)/$(echo "\n$ ")'
}

# Actually set the prompt by calling the function
prompt

#function prompt()
#{
#  # Bail out if running in non-interactive mode
#  if [ -z "$PS1" ]; then
#    return
#  fi
#
#  #local BLACK="\[\033[0;30m\]"
#  #local RED="\[\033[0;31m\]"
#  #local GREEN="\[\033[0;32m\]"
#  #local BROWN="\[\033[0;33m\]"
#  local BLUE="\[\033[0;34m\]"
#  #local PURPLE="\[\033[0;35m\]"
#  #local CYAN="\[\033[0;36m\]"
#  #local LIGHT_GRAY="\[\033[0;37m\]"
#  #
#  #local DARK_GRAY="\[\033[1;30m\]"
#  #local LIGHT_RED="\[\033[1;31m\]"
#  #local LIGHT_GREEN="\[\033[1;32m\]"
#  #local YELLOW="\[\033[1;33m\]"
#  #local LIGHT_BLUE="\[\033[1;34m\]"
#  #local LIGHT_PURPLE="\[\033[1;35m\]"
#  #local LIGHT_CYAN="\[\033[1;36m\]"
#  #local LIGHT_GRAY="\[\033[1;37m\]"
#  #
#  local NO_COLOUR="\[\033[0m\]"
#
#  #PS1="$TITLEBAR\
#  #$YELLOW-$LIGHT_BLUE-(\
#  #$YELLOW\u$LIGHT_BLUE@$YELLOW\h\
#  #$LIGHT_BLUE)-(\
#  #$YELLOW\$PWD\
#  #$LIGHT_BLUE)-$YELLOW-\
#  #\n\
#  #$YELLOW-$LIGHT_BLUE-(\
#  #$YELLOW\$(date +%H%M)$LIGHT_BLUE:$YELLOW\$(date \"+%a,%d %b %y\")\
#  #$LIGHT_BLUE:$WHITE\\$ $LIGHT_BLUE)-$YELLOW-$NO_COLOUR "
#
#  #cd cdPS2="$LIGHT_BLUE-$YELLOW-$YELLOW-$NO_COLOUR "
#
#  case $TERM in
#      xterm*|rxvt*)
#          TITLEBAR='\[\033]0;\u@\h:\w\007\]'
#          ;;
#      *)
#          TITLEBAR=""
#          ;;
#  esac
#
#  alias escape_path='sed -e "s/\//\\\\\//g"'
#
#  ESC_HOME=$(echo $HOME | escape_path)
#  ESC_PROJECT=$(echo $HOME/rockmelt/src | escape_path)
#  ESC_NEXT=$(echo $HOME/rockmelt/next/src | escape_path)
#  ESC_MAINT=$(echo $HOME/rockmelt/maint/src | escape_path)
#  ESC_PLATFORM=$(echo $HOME/rockmelt/extensions | escape_path)
#  ESC_FAST=$(echo $HOME/rockmelt/fast/src | escape_path)
#  ESC_BACK=$(echo $HOME/rockmelt/backend-assets/feeds | escape_path)
#
#  PS1='$(echo $PWD | sed -e "s/$ESC_PLATFORM/\(E\)/" | sed -e "s/$ESC_FAST/\(F\)/" | sed -e "s/$ESC_BACK/\(B\)/" | sed -e "s/$ESC_PROJECT/@/" | sed -e "s/$ESC_NEXT/\(N\)/" | sed -e "s/$ESC_MAINT/\(M\)/" |sed -e "s/$ESC_HOME/~/") > '
#  #PS1=$BLUE$PS1$NO_COLOUR
#}
