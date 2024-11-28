#!/usr/bin/env bash
load_brew() { 
    test -f /home/linuxbrew/.linuxbrew/bin/brew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"; 
    test -f /opt/homebrew/bin/brew && eval "$(/opt/homebrew/bin/brew shellenv)"; 

    os_name=$(uname -s)
    if [[ "$os_name" == "Darwin" ]]; then
        brewser=$(stat -f "%Su" $(which brew))
        unalias brew 2>/dev/null
        brew='sudo -Hu '$brewser' brew'
        alias brew=$brew
    fi
}