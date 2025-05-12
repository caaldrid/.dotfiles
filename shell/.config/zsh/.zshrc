# Init brew env !!![NEEDS TO BE FIRST]!!!
source "$HOME/.local/scripts/load_brew.sh"
load_brew

# Setup XDG folders
source "$HOME/.config/user-dirs.dirs"

# Update Completions
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:$(brew --prefix)/Cellar/fzf/0.54.3/shell/completion.zsh:${FPATH}"
os_name=$(uname -s)
  autoload -Uz compinit
  if [[ "$os_name" == "Darwin" ]]; then
    compinit -u
  else
    compinit
  fi

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

# Enable Docker Socket
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock

# Pull in all my custom functions
source $XDG_CONFIG_HOME/custom/functions.zsh

# Update $PATH for my set-up
source $XDG_CONFIG_HOME/custom/paths.zsh

# Pull in all my custom functions
source $XDG_CONFIG_HOME/custom/aliases.zsh

# Pull in all my custom keybinds
source $XDG_CONFIG_HOME/custom/keybinds.zsh

