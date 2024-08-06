#!/usr/bin/env zsh

# Default values
clean_only=false

# Function to handle long options
parse_long_options() {
  while [[ $# -gt 0 ]]; do
    case $1 in
      --clean-only)
        clean_only=true
        shift
        ;;
      --)
        shift
        break
        ;;
      -*)
        echo "Unknown option: $1"
        exit 1
        ;;
      *)
        break
        ;;
    esac
  done
}

# Parse single-dash options first
while getopts "c" opt; do
  case ${opt} in
    c )
      clean_only=true
      ;;
    \? )
      echo "Usage: cmd [-c] [--clean-only]"
      exit 1
      ;;
  esac
done

# Shift away the processed single-dash options
shift $((OPTIND -1))

# Now handle long options
parse_long_options "$@"


# Make sure the default shell is a zsh
if [[ ! "$SHELL" ==  *"zsh"* ]]; then
	echo >&2 "We expect zsh is set as the default shell"
	exit 1
fi

# Throw an error if stow is not installed
command=stow
if ! which $command >/dev/null 2>&1; then
    echo >&2 "The command $command is not installed. Please install it"
    exit 1
fi

# Capture the output of uname -s
os_name=$(uname -s)

# Load parameters based on the os
if [ "$os_name" = "Linux" ]; then
	if [ -f "./script-params/linux" ]; then
		source ./script-params/linux
	else
		echo >&2 "The file \`script-params/linux\` corresponding to $os_name OS is missing in $pwd"
		exit 1
	fi
else
	echo >&2 "$os_name is not supported"
	exit 1
fi

echo "Will now iterate through the following directories: \n\t- $(echo $FOLDERS_TO_STOW | sed "s/,/\n\t- /g")"

# Loop through the given folders that we are told to stow and run command
for folder in $(echo $FOLDERS_TO_STOW | sed "s/,/ /g")
do
	if [ -d "./$folder" ];then
		echo "\n----------Processing $folder----------"
	    	stow -v --target=$HOME -D $folder
	    	$clean_only || stow -v --target=$HOME $folder # don't run if we are in clean-only mode
	else
		echo >&2 "$folder does not exist in $pwd"
		exit 1
	fi
done
