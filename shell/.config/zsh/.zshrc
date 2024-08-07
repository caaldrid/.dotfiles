# Pull in all my custom functions
source $XDG_CONFIG_HOME/custom/functions.zsh

# Update $PATH for my set-up
source $XDG_CONFIG_HOME/custom/paths.zsh

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load 
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
source ~/.p10k.zsh

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# Oh-My-ZSH init
source $ZSH/oh-my-zsh.sh

# Init brew env !!![NEEDS TO BE BEFORE THE ATUIN LINE]!!!
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Initialize atuin
eval "$(atuin init zsh)"

# Initialize zoxide and overwrites the cd command
eval "$(zoxide init --cmd=cd zsh)"

# Enable vivid color theme
export LS_COLORS="$(vivid generate molokai)"

# Pull in all my custom functions
source $XDG_CONFIG_HOME/custom/aliases.zsh
