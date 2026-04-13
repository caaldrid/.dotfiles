addToPath "$HOME/go/bin"
addToPath "$HOME/.cargo/bin"
addToPath "$HOME/.local/scripts"
addToPath "$HOME/.local/bin"
addToPath "$HOME/.docker/bin/"

os_name=$(uname -s)
if [[ "$os_name" == "Darwin" ]]; then
	addToPath "/Applications/Obsidian.app/Contents/MacOS"
fi
