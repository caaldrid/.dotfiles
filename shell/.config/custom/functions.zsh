#!/usr/bin/env zsh

addToPath() {
    if [[ "$PATH" != *"$1"* ]]; then
        export PATH=$PATH:$1
    fi
}

addToPathFront() {
    if [[ "$PATH" != *"$1"* ]]; then
        export PATH=$1:$PATH
    fi
}

# Current active GitHub username (if needed)
gh_active_user() {
   gh auth status -a --json hosts --jq '.hosts | add | .[0].login' 2>/dev/null || echo "No User"
}

# Switch GitHub user silently
switch_gh_user() {
    if [[ "$PWD" == "$HOME/Code/work/"* ]]; then
        git config get user.username | xargs gh auth switch -u 2>/dev/null
    else
        gh auth switch -u caaldrid 2>/dev/null
    fi
}
