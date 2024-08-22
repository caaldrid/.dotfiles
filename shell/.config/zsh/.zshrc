# Init brew env !!![NEEDS TO BE FIRST]!!!
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Update Completions
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi

# Initialize atuin
eval "$(atuin init zsh)"

# Initialize zoxide and overwrites the cd command
eval "$(zoxide init --cmd=cd zsh)"

# Initialize oh-my-posh and set theme
eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/theme.omp.json)"

# Enable vivid color theme
export LS_COLORS="$(vivid generate molokai)"

# Enable NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" # This loads nvm

# Pull in all my custom functions
source $XDG_CONFIG_HOME/custom/functions.zsh

# Update $PATH for my set-up
source $XDG_CONFIG_HOME/custom/paths.zsh

# Pull in all my custom functions
source $XDG_CONFIG_HOME/custom/aliases.zsh
