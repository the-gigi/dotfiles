export EDITOR=vim

# Don't save commands that have a space prefix in the history
export HISTCONTROL=ignorespace

# Show time for each command in the history
setopt EXTENDED_HISTORY

# Enable the repeat command
enable -r repeat

alias shrug='echo "¯\_(ツ)_/¯"'

# Directory listing in a nice format
alias lla='ls -laGh'

# Disk usage that also sorts the results by size and saves to a file
alias dus='du -Pscmx * | sort -nr | tee disk_usage.txt'

# Concise dig to resolve DNS names
alias dg='dig +noall +answer'

# Find who listens on any of the target ports
function find_listeners
{
  for port in "$@"
  do
    lsof -nP -iTCP:${port} | grep LISTEN | awk '{ print $2 }' | sort -u
  done
}

# Kill whoever listens on any of the target ports
function kill_listeners {
  for port in "$@"; do
    listeners=$(find_listeners $port)
    if [ -n "$listeners" ]; then
      echo "Killing listeners on port $port:"
      # Iterate over each listener PID
      while IFS= read -r listener; do
        if [ -n "$listener" ]; then
          echo "  Killing listener PID: $listener"
          kill -9 "$listener"
        fi
      done <<< "$listeners"
    else
      echo "No listeners found on port $port"
    fi
  done
}

# This code should run on Debian-based systems
function install_basic_tools()
{
    apt update  -y
    apt install -y git tmux htop dnsutils
}

# Run sqlite commands directly (need to quote if using * in query)
function sq
{
    sqlite3 $SQLITE_DB_NAME "$*;"
}

# Better CLI
#alias cat='bat'
alias grep='rg'
alias man='tldr'

# Remove the prefix from all files in the current directory
function remove_prefix_in_current_dir()
{
    profix=$1
    for f in  "$prefix"*;do mv "$f" "${f#"$prefix"}";done
}

# Load colors
autoload colors && colors
for COLOR in RED GREEN YELLOW BLUE MAGENTA PURPLE CYAN BLACK WHITE; do
    eval $COLOR='%{$fg_no_bold[${(L)COLOR}]%}'  # wrap colours between %{ %} to avoid weird gaps in autocomplete
    eval BOLD_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
done
eval RESET='%{$reset_color%}'
