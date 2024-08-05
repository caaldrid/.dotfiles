# Specify where I store all the custom set-up scripts
export CUSTOM_CONFIG=./../custom

# Pull in all of my custom variables
source $CUSTOM_CONFIG/variables.zsh

# Pull in all my custom functions
source $CUSTOM_CONFIG/functions.zsh

# Update $PATH for my set-up
source $CUSTOM_CONFIG/paths.zsh
