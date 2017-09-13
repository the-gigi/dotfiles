# -----------------------------------------------
# This file should be sourced from your ~/.bashrc 
# -----------------------------------------------

export GIT_HOME=~/git
export EDITOR=vim

####################
#
#   P A T H
#
####################
# export PATH="$PATH:"

####################
#
#  S Y S   A D M I N
#
####################
# Directory listing in a nice format
alias lla='ls -lAGh'

alias edb='vim ~/git/dotfiles/.bashrc; exec bash'


# Disk usage that also sorts the results by size and saves to a file
alias dus='du -Pscmx * | sort -nr | tee disk_usage.txt'

function find_listeners
{
  for port in "$@"
  do
    lsof -i | grep LISTEN | grep "$port" | awk '{ print $2 }'
  done
}

function kill_listeners
{
  for port in "$@"
  do
    listener=$(find_listeners $port)
    if [ -n "$listener" ]; then
      echo "Killing listener: $listener"
      kill -9 "$listener"
    fi
  done
}



####################
#
# N A V I G A T I O N
#
####################
alias cdg='cd $GIT_HOME'


#################
#
# SSH
#
#################
# Turn on ssh-agent
eval "$(ssh-agent -s)" &> /dev/null

# Add Gitgub ssh key to the agent
ssh-add ~/.ssh/github_id_rsa &> /dev/null

#############
#
# P R O M P T
#
#############
# export PS1='\[\033]0;$TITLEPREFIX:${PWD//[^[:ascii:]]/?}\007\]\n \[\033[33m\]\w\[\033[36m\]`__git_ps1`\[\033[0m\]\n$ '

##############
#
#   C O N D A
#
##############
alias a='source activate'
alias cel='conda env list'


###########################
#
#   G I T
#
###########################
alias g='git'
alias gci='git commit -a'
alias gcia='git commit -a --amend'
alias gb='git branch'
alias gbd='git branch -D'
alias gco='git checkout'
alias gpu='git pull --rebase'
alias gg='git grep -i'
alias gs='git status -uno'
alias gd='git diff'
alias gl='git log --oneline'


# Show all untracked files and directories in current dir
alias ng='git clean -n -d .'

# Create remote git branch (and local too) from master
function gbr
{
    gco master
    gb $1
    g push -u origin $1
    gco $1
}

# Check if git repo has changed changed (master vs. origin/master)
function has_repo_changed() {
    pushd . > /dev/null
    cd "$1" > /dev/null
    modified=$(git remote -v update 2>&1 | grep master | grep -v "up to date")
    popd > /dev/null
    if [[ "$modified" -eq '' ]]
        then
            return 1 # False
        else
            return 0 # True
    fi
}

###########################
#
#   D O C K E R
#
###########################
alias d='sudo docker'
# If user is root no need for sudo
if [ "$(id -u)" == "0" ]; then   
  alias d='docker'
fi

# If running on Mac (Darwin) no need for sudo
if [ "$(uname)" == "Darwin" ]; then
  alias d='docker'
fi

alias di='d images'
alias dps='d ps'
alias dpsa='dps -a'

function dex
{ 
    d exec -it "$1" /bin/bash
}

###########################
#
#   K U B E R N E T E S
#
###########################
alias k='kubectl'
alias kg='k get'
alias kd='k describe'


##########################
#
# B A S I C   T O O L S
#
##########################
function install_basic_tools()
{
    apt update  -y
    apt install -y git tmux htop
}

###############
#
#   S Q L I T E
#
###############
# Run sqlite commands directly (need to quote if using * in query)
function sq
{
    sqlite3 $SQLITE_DB_NAME "$*;"
}
