export GIT_HOME=~/git

alias g='git'
alias gci='git commit -a'
alias gcia='git commit -a --amend'
alias gb='git branch'
alias gbd='git branch -D'
alias gbc='git branch --show=current' | pbcopy
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

# Create remote git branch (and local too) from master
function git_create_remote_branch() {
  gco master
  gpu
  gb $1
  g push -u origin $1
  gco $1
}
alias gcrb='git_create_remote_branch'

# Push current branch to remote (bail out of on master)
function git_push_remote_branch() {
  curr=$(git branch --show-current)
  if [[ "$curr" -eq "master" ]]; then
    echo "You're on master. Switch to another branch"
    return 1
  fi

  gs -u | grep 'nothing to commit, working tree clean'
  if [ $? -ne 0 ]; then
    "Working tree is not clean"
  fi

  g push origin "$curr"
}
alias gprb='git_push_remote_branch'

# Rebase the current branch on master
function git_rebase_on_master() {
  curr=$(git branch --show-current)
  gco master
  gpu
  gco $curr
  g rebase master
}
alias grom='git_rebase_on_master'

# Check if git repo has changed changed (master vs. origin/master)
function git_has_repo_changed() {
  pushd . > /dev/null
  cd "$1" > /dev/null || exit 2
  modified=$(git remote -v update 2>&1 | grep master | grep -v "up to date")
  popd > /dev/null || exit 2
  if [[ "$modified" -eq '' ]]; then
    return 1 # False
  else
    return 0 # True
  fi
}
