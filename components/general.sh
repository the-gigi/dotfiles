export EDITOR=vim

# Don't save commands that have a space prefix in the history
export HISTCONTROL=ignorespace

# Enable the repeat command
enable -r repeat

alias shrug='echo "¯\_(ツ)_/¯"'

# Directory listing in a nice format
alias lla='ls -lAGh'

# Disk usage that also sorts the results by size and saves to a file
alias dus='du -Pscmx * | sort -nr | tee disk_usage.txt'

# Concise dig to reolve DNS names
alias dg='dig +noall +answer'

# Find who listens on any of the target ports
function find_listeners
{
  for port in "$@"
  do
    lsof -i | grep LISTEN | grep "$port" | awk '{ print $2 }'
  done
}

# Kill whoever listens on any of the target ports
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

# This code should run on Debian-based systems
function install_basic_tools()
{
    apt update  -y
    apt install -y git tmux htop
}

# Run sqlite commands directly (need to quote if using * in query)
function sq
{
    sqlite3 $SQLITE_DB_NAME "$*;"
}

# Better CLI
#alias cat='bat'
#alias grep='rg'
#alias man='tldr'