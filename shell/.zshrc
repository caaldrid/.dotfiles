# Set ZDOTDIR to point to the directory where your zsh configurations are stored
export XDG_CONFIG_HOME="$HOME/.config"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Source the main .zshrc from the new location
if [ -f "$ZDOTDIR/.zshrc" ]; then
    source "$ZDOTDIR/.zshrc"
fi
