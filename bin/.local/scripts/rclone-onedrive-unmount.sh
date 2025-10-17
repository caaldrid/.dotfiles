#!/usr/bin/env bash
test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fusermount -u $HOME/OneDrive
