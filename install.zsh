#!/usr/bin/env zsh

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

echo "Will now stow the following directories: \n\t- $(echo $FOLDERS_TO_STOW | sed "s/,/\n\t- /g")"

# Loop through the given folders that we are told to stow and run command
for folder in $(echo $FOLDERS_TO_STOW | sed "s/,/ /g")
do
	if [ -d "./$folder" ];then
		echo "\n----------Stowing $folder----------"
	    	stow -v --target=$HOME -D $folder
	    	stow -v --target=$HOME $folder
	else
		echo >&2 "$folder does not exist in $pwd"
		exit 1
	fi
done
