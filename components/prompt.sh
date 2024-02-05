# DEPRECATED! moved to [Powerlevel10K](https://github.com/romkatv/powerlevel10k)
# Just here for historical purposes.
# It's a pretty fancy bit of shell/prompt spells
#

##! /usr/bin/env zsh
#
#script_name=${(%):-%N}
#PROMPT_DIR="$(cd "$(dirname "$script_name")" >/dev/null 2>&1 && pwd)"
#
#source "$(brew --prefix)/opt/kube-ps1/share/kube-ps1.sh"
#
#alias escape_path='sed -e "s/\//\\\\\//g"'
#
#function get_paths()
#{
#  envsubst < <(cat ~/.dotfiles.local/paths.txt "${PROMPT_DIR}/paths.txt")
#}
#
#function calc_current_dir()
#{
#  cwd=$PWD
#  while IFS=":" read -r key value _
#  do
#    if [[ $PWD == *"${key}"* ]]; then
#      key=$(echo "$key" | escape_path)
#      # In theory this works cwd=${PWD/$key/$value}
#      # In practice it doesn't :-)
#      cwd=$(echo "$PWD" | sed -e "s/$key/$(echo $value)/")
#      break
#    fi
#  done < <(get_paths)
#  echo "${cwd}"
#}
#
#current_git_branch_file=$(mktemp)
#update_current_git_branch_log=$(mktemp)
#touch $current_git_branch_file
#
#function _update_current_git_branch() {
#    git branch --show-current &> $1
#    result=$(cat $1)
#
#    echo "result: ${result}" >> $update_current_git_branch_log
#
#    if [[ $result =~ "^fatal: not a git repository" ]]; then
#      echo "<not a git repo>" > $1
#    fi
#}
#function update_current_git_branch() {
#    while true; do
#      timestamp=$(date +"[%H:%M:%S]")
#      echo "${timestamp} calling update_current_git_branch()" >> $update_current_git_branch_log
#      _update_current_git_branch $current_git_branch_file
#      sleep 10
#    done
#}
#
#function current_line() {
#  echo -ne "\033[6n" > /dev/tty
#  read -t 1 -s -d 'R' line < /dev/tty
#  line="${line##*\[}"
#  line="${line%;*}"
#  echo "$line"
#}
#
#function display_status()
#{
#  light_green_bg='\e[48;5;118m'
#  bright_black='\e[38;5;232m'
#  reset='\e[39m'
#
#  line=0
#  if [[ $(current_line) -eq $(tput lines) ]]; then
#    line=1
#  fi
#
#  # Display Kubernetes context + namespace and git branch at the top right-corner
##  local current_git_branch
##  current_git_branch=$(cat $current_git_branch_file)
##  info="${KUBE_PS1_CONTEXT} | ${KUBE_PS1_NAMESPACE} | ${current_git_branch}"
#  info="${KUBE_PS1_CONTEXT} | ${KUBE_PS1_NAMESPACE}"
#  tput sc;tput cup $line $(($(tput cols)-${#${info}}-2));echo -e "${light_green_bg}${bright_black} ${info} ${reset}";tput rc
#}
#
#update_current_git_branch_pid=''
#function install_status() {
#  # Add display_status() as a preexec hook
#  add-zsh-hook precmd display_status
#
##  # Run the update_current_git_branch() function in the background
##  update_current_git_branch &
##  clear
##  update_current_git_branch_pid=$(echo $!)
##  echo "update_current_git_branch_pid: $update_current_git_branch_pid"
##  echo "update_current_git_branch_log: $update_current_git_branch_log"
##  echo "current_git_branch_file: $current_git_branch_file"
#}
#
#function prompt()
#{
#  # Bail out if running in non-interactive mode
#  if [ -z "$PS1" ]; then
#    return
#  fi
#
#  # doesn't work without it
#  setopt promptsubst
#
#  # Display time + current dir in the prompt line
#  export PS1='$(date +"[%H:%M:%S]") $(calc_current_dir)/$(echo "\n$ ")'
#  # export PS1='$(date +"[%H:%M:%S]") $(echo "\n$ ")'
#}
#
## Actually set the prompt by calling the function
#prompt
#
## Install the status
#sched +2 install_status
#
