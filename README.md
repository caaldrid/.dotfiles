# .dotfiles
A repository for me to save the general set-up of my terminal based dev environment. Includes package installation

## Currently used to set up:
- WSL Ubuntu

## External Tools used
- [stow util](https://www.gnu.org/software/stow/)
- [Brew](brew.sh)
- [DevelopersToolbox/ini-file-parser](https://github.com/DevelopersToolbox/ini-file-parser)

## Docker
This repo includes an ubuntu dockerfile to help better test this script as it requires a clean enviroment each time. Run the following commands from the root of the repo to properly build the image as it creates a user with password/sudo rights that you need to specify at buildtime.

1. ```$IMAGE_USER=<< SET YOUR USERNAME HERE >>```
1. ```$PSWD=$(echo "<< PUT YOUR PASSWORD HERE >>" | openssl passwd -6 -stdin)```
1. ```docker buildx build --build-arg="USERNAME=$($IMAGE_USER)" --build-arg="USER_PASSWORD_HASH=$(PSWD)" -t test_dev_env:latest .```
1. ```docker run --rm -it --mount type=bind,source="<< PUT REPO ROOT PATH >>"/,target="/home/$(IMAGE_USER)/src" test_dev_env```
