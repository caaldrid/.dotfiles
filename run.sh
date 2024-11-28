#!/usr/bin/env bash
declare stow_folders_keys
declare pkgs_keys

usage() {
  echo "Usage: $0 [-c <true|false>: Sets script to just clean up]" 1>&2
  exit 1
}


OPT_C=false
OPT_S=false
OPTIND=1

while getopts "cs" opt; do
  case $opt in
  c)
    OPT_C=true
    ;;
  s)
    OPT_S=true
    ;;
  *) usage ;;
  esac
done
shift $((OPTIND - 1))

# Source ini-file-parser from the web to unlock functions for reading the config.ini file
# shellcheck source=https://raw.githubusercontent.com/developerstoolbox/ini-file-parser/HEAD/src/ini-file-parser.sh
source /dev/stdin <<< "$(curl -fsSL https://raw.githubusercontent.com/developerstoolbox/ini-file-parser/HEAD/src/ini-file-parser.sh)"

# Determine project directory and process the config file
project_dir=$(dirname "$(readlink -f "$0")")
config_path="$project_dir/config.ini"
process_ini_file "$config_path"

# Load brew into PATH
source "$project_dir/bin/.local/scripts/load_brew.sh"
load_brew

if [ "$OPT_S" = false ] && [ "$OPT_C" = false ]; then
  # Install brew if we don't have it already
  if ! which brew >/dev/null 2>&1; then
    bash <(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)

    # Load brew into PATH again incase we didn't before
    load_brew
  fi

  # Make sure we know where brew is
  if ! which brew >/dev/null 2>&1; then
    echo >&2 "brew is still not in PATH"
    exit 1
  fi

  # Make sure we are in the home dir before we install packages
  pushd "$HOME" || exit

  # Iterate through the pkgs config section to install programs
  for pkg_installer in ${pkgs_keys[@]}; do
    install_cmd=$(get_value "installer_cmd" "$pkg_installer")

    # Make sure to user brewuser on mac
    if [[ "$pkg_installer" == "brew" ]]; then
      os_name=$(uname -s)
      if [[ "$os_name" == "Darwin" ]]; then
        install_cmd="sudo -Hu '$brewser' brew install"
        echo $install_cmd
      fi
    fi

    pkg_list=$(get_value "pkgs" "$pkg_installer")

    for pkg in $(echo "$pkg_list" | sed "s/,/ /g"); do

      installation_name=$pkg

      # Parse the package name from the github url so we can check if that's installed
      if [[ "$pkg_installer" == "go" ]]; then
        installation_name=$(echo "$pkg" | grep -Po "(?<=\/)\w+(?=@)")
      fi

      # Install the package if its not already installed
      if which "$installation_name" >/dev/null 2>&1; then
        echo "$pkg is already installed. Skipping..."
      else
        # Still uses pkg since that has the full package name needed for go
        cmd="$install_cmd $pkg"

        eval "$cmd"
      fi
    done
  done

  # Return to the original directory we were at
  popd || exit
fi

# Run the .dotfile script to set up configurations
printf "\n---------- SETTING UP CONFIGS  ----------"
# Throw an error if stow is not installed
command=stow
if ! which $command >/dev/null 2>&1; then
  echo >&2 "The command $command is not installed. Please install it"
  exit 1
fi

# Find the name of our current OS
# curr_os=$(uname -s)

# Iterate through the pkgs config section to install programs
for os_name in ${stow_folders_keys[@]}; do
  stow_folders=$(get_value "stow_folders" "$os_name")

  printf "\nWill now iterate through the following directories: \n\t- $(echo "$stow_folders" | sed "s/,/\n\t- /g")"

  for folder_name in $(echo "$stow_folders" | sed "s/,/ /g"); do
    target=$project_dir/$folder_name

    if [ -d "$target" ]; then
      printf "\n----------Processing %s----------\n" "$folder_name"
      stow -v --target="$HOME" --dir="$project_dir" -D "$folder_name"
      $OPT_C || stow -v --target="$HOME" --dir="$project_dir" "$folder_name"
    else
      echo >&2 "$folder_name does not exist in $project_dir"
      exit 1
    fi
  done
done

exit 0
