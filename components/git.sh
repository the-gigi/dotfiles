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

function git_is_current_branch_primary {
  primary=$(git_get_primary_branch)
  curr=$(git branch --show-current)

  if [ "$curr" = "$primary" ]; then
    return 0
  else
    return 1
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

# Never delete the primary
function git_delete_current_branch {
  # Define the name of the primary branch (adjust the function name if necessary)
  primary=$(git_get_primary_branch)

  # Save current branch name
  current_branch=$(git branch --show-current)

  # If on primary branch, bail out
  if [ "$current_branch" = "$primary" ]; then
    echo "You are on the primary branch ($primary). Cannot delete."
    return 1
  fi

  # Switch to primary branch
  if ! git checkout "$primary"; then
    echo "Failed to switch to primary branch ($primary)."
    return 1
  fi

  # Delete the saved branch
  if ! git branch -d "$current_branch"; then
    echo "Failed to delete branch $current_branch. Consider using -D to force."
    return 1
  fi

  # Optionally, rebase primary branch
  echo "Rebasing $primary..."
  # shellcheck disable=SC2086
  if ! git pull --rebase origin "$primary"; then
    echo "Rebase failed. Please check for conflicts."
    return 1
  fi

  echo "Branch $current_branch deleted and $primary rebased."
}

alias gbdd='git_delete_current_branch'


# Create git tag locally and remotely
git_tag() {
  if [[ -z "$1" ]]; then
    echo "Usage: git_tag <tag name>"
    return 1
  fi
  git tag "$1" && git push --tags
}

alias gt='git_tag'

# Delete a git tag locally and remotely
git_delete_tag() {
  if [[ -z "$1" ]]; then
    echo "Usage: git_delete_tag <tag name>"
    return 1
  fi
  git tag -d "$1" && git push origin --delete tag "$1"
}

alias gdt='git_delete_tag'

# Show branches with their associated PR information
function git_branch_enhanced() {
  # Colors
  local GREEN='\033[0;32m'
  local YELLOW='\033[0;33m'
  local CYAN='\033[0;36m'
  local MAGENTA='\033[0;35m'
  local GRAY='\033[0;90m'
  local NC='\033[0m' # No Color

  # Get all local branches
  local branches
  branches=$(git branch --format='%(refname:short)')

  # Print header
  echo -e "$(printf "%-40s %-20s %-10s %s" "BRANCH" "REVIEW" "STATE" "PR URL")"
  echo -e "$(printf "%-40s %-20s %-10s %s" "========================================" "====================" "==========" "==================================================")"

  # For each branch, try to get PR info
  while IFS= read -r branch; do
    # Try to get PR info using gh (GitHub CLI)
    local pr_info
    pr_info=$(gh pr view "$branch" --json reviewDecision,state,url 2>/dev/null)

    if [ $? -eq 0 ] && [ -n "$pr_info" ]; then
      # Extract fields from JSON
      local review state url
      review=$(echo "$pr_info" | jq -r '.reviewDecision // "NONE"')
      state=$(echo "$pr_info" | jq -r '.state // "N/A"')
      url=$(echo "$pr_info" | jq -r '.url // "N/A"')

      # Color coding based on review decision
      local review_display
      case "$review" in
        "APPROVED")
          review_display="${GREEN}${review}${NC}"
          ;;
        "REVIEW_REQUIRED"|"CHANGES_REQUESTED")
          review_display="${YELLOW}${review}${NC}"
          ;;
        *)
          review_display="$review"
          ;;
      esac

      # Color coding based on state
      local state_display
      case "$state" in
        "OPEN")
          state_display="${CYAN}${state}${NC}"
          ;;
        "MERGED")
          state_display="${MAGENTA}${state}${NC}"
          ;;
        "CLOSED")
          state_display="${GRAY}${state}${NC}"
          ;;
        *)
          state_display="$state"
          ;;
      esac

      # Calculate padding (accounting for color codes add extra chars)
      local review_len state_len review_pad state_pad
      review_len=${#review}
      state_len=${#state}
      review_pad=$((20 - review_len))
      state_pad=$((10 - state_len))

      echo -e "$(printf "%-40s" "$branch") ${review_display}$(printf "%${review_pad}s" "") ${state_display}$(printf "%${state_pad}s" "") ${url}"
    else
      # No PR found
      echo -e "$(printf "%-40s %-20s %-10s %s" "$branch" "-" "-" "-")"
    fi
  done <<< "$branches"
}

alias gbx='git_branch_enhanced'


