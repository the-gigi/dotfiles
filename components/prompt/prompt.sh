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

current_git_branch_file=$(mktemp)
update_current_git_branch_log=$(mktemp)
touch $current_git_branch_file

function _update_current_git_branch() {
    git branch --show-current &> $1
    result=$(cat $1)

    echo "result: ${result}" >> $update_current_git_branch_log

    if [[ $result =~ "^fatal: not a git repository" ]]; then
      echo "<not a git repo>" > $1
    fi
}
function update_current_git_branch() {
    while true; do
      timestamp=$(date +"[%H:%M:%S]")
      echo "${timestamp} calling update_current_git_branch()" >> $update_current_git_branch_log
      _update_current_git_branch $current_git_branch_file
      sleep 10
    done
}

function current_line() {
  echo -ne "\033[6n" > /dev/tty
  read -t 1 -s -d 'R' line < /dev/tty
  line="${line##*\[}"
  line="${line%;*}"
  echo "$line"
}

function display_status()
{
  light_green_bg='\e[48;5;118m'
  bright_black='\e[38;5;232m'
  reset='\e[39m'

  line=0
  if [[ $(current_line) -eq $(tput lines) ]]; then
    line=1
  fi

  # Display Kubernetes context + namespace and git branch at the top right-corner
#  local current_git_branch
#  current_git_branch=$(cat $current_git_branch_file)
#  info="${KUBE_PS1_CONTEXT} | ${KUBE_PS1_NAMESPACE} | ${current_git_branch}"
  info="${KUBE_PS1_CONTEXT} | ${KUBE_PS1_NAMESPACE}"
  tput sc;tput cup $line $(($(tput cols)-${#${info}}-2));echo -e "${light_green_bg}${bright_black} ${info} ${reset}";tput rc
}

update_current_git_branch_pid=''
function install_status() {
  # Add kube-ps1 to .zshrc if needed
  kube_ps1_in_zshrc=$(grep 'source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"' ~/.zshrc)
  if [[ ! -n "${kube_ps1_in_zshrc}" ]]; then
    echo 'source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"' >> ~/.zshrc
  fi

  # Add status() as a preexec hook
  add-zsh-hook precmd display_status

#  # Run the update_current_git_branch() function in the background
#  update_current_git_branch &
#  clear
#  update_current_git_branch_pid=$(echo $!)
#  echo "update_current_git_branch_pid: $update_current_git_branch_pid"
#  echo "update_current_git_branch_log: $update_current_git_branch_log"
#  echo "current_git_branch_file: $current_git_branch_file"
}

function prompt()
{
  # Bail out if running in non-interactive mode
  if [ -z "$PS1" ]; then
    return
  fi

  # doesn't work without it
  setopt promptsubst

  # Display time + current dir in the prompt line
  export PS1='$(date +"[%H:%M:%S]") $(calc_current_dir)/$(echo "\n$ ")'
}

# Actually set the prompt by calling the function
prompt

# Install the status
sched +10 install_status

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
