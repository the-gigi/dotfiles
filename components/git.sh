export GIT_HOME=~/git

alias g='git'
alias gci='git commit -a'
alias gcia='git commit -a --amend'
alias gb='git branch'
alias gbd='git branch -D'
alias gbc='git branch --show-current | pbcopy'
alias gru='git config --get remote.origin.url | pbcopy'
alias gco='git checkout'
alias gpu='git pull --rebase'
alias gg='git grep -i'
alias gs='git status -uno'
alias gd='git diff'
alias gl='git log --oneline'

# Show all untracked files and directories in current dir
alias gu='git clean -n -d .'

# Clean all untracked files and directories under current dir
alias gx='git clean -f -d'

# Create remote git branch (and local too) from primary branch
function git_create_remote_branch() {
  primary=$(git_get_primary_branch)
  gco "$primary"
  gpu
  gb "$1"
  g push -u origin "$1"
  gco "$1"
}
alias gcrb='git_create_remote_branch'

# Push current branch to remote (bail out of on master)
function git_push_remote_branch() {
  primary=$(git_get_primary_branch)
  curr=$(git branch --show-current)
  if [[ "$curr" -eq "$primary" ]]; then
    echo "You're on ${primary}. Switch to another branch"
    return 1
  fi

  gs -u | grep 'nothing to commit, working tree clean'
  if [ $? -ne 0 ]; then
    "Working tree is not clean"
  fi

  g push origin "$curr"
}
alias gprb='git_push_remote_branch'

# Get the primary git branch (main or master)
#
# If both exist prefer main
# If none exist fail
function git_get_primary_branch() {
  if git rev-parse --verify main &> /dev/null; then
    echo main
  elif git rev-parse --verify master &> /dev/null; then
    echo master
  else
    echo "No 'main' and no 'master' branches exist"
    return 1
  fi
}

# Rebase the current branch on the primary branch (master or main)
#
# If both exist prefer main
# If none exist fail
function git_rebase_on_primary() {
  if ! primary=$(git_get_primary_branch); then
    echo "$primary"
    return 1
  fi
  curr=$(git branch --show-current)
  gco "$primary"
  gpu
  gco "$curr"
  g rebase "$primary"
}
alias grop='git_rebase_on_primary'

# Check if git repo has changed
#
# Compare the local primary branch (main or master) against the remote
function git_has_repo_changed() {
  if ! primary=$(git_get_primary_branch); then
    echo "$primary"
    return 1
  fi

  pushd . > /dev/null
  cd "$1" > /dev/null || exit 2
  modified=$(git remote -v update 2>&1 | grep "$primary" | grep -v "up to date")
  popd > /dev/null || exit 2
  if [[ "$modified" -eq '' ]]; then
    return 1 # False
  else
    return 0 # True
  fi
}

# Register large git repos (especially monorepos) with scalar
# See https://github.com/microsoft/scalar
function scalar_register() {
  while IFS= read -r "$item"
  do
    (cd "$item" && scalar register)
  done < "${LOCAL_DOT_DIR}/git-repos.txt"
}
