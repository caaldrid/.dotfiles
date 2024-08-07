# Init brew env !!![NEEDS TO BE FIRST]!!!
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Initialize atuin
eval "$(atuin init zsh)"

# Initialize zoxide and overwrites the cd command
eval "$(zoxide init --cmd=cd zsh)"

# Initialize oh-my-posh and set theme
eval "$(oh-my-posh init zsh --config $(brew --prefix oh-my-posh)/themes/powerlevel10k_rainbow.omp.json)"

# Enable vivid color theme
export LS_COLORS="$(vivid generate molokai)"

# Pull in all my custom functions
source $XDG_CONFIG_HOME/custom/functions.zsh

# Update $PATH for my set-up
source $XDG_CONFIG_HOME/custom/paths.zsh

# Pull in all my custom functions
source $XDG_CONFIG_HOME/custom/aliases.zsh
