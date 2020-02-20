export GIT_HOME=~/git

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