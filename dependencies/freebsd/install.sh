#!/usr/bin/env sh

packages="coreutils fzf bash curl mosh gnupg pass ripgrep vim zsh tmux"

install_command="env ASSUME_ALWAYS_YES=YES pkg install $packages"

if [[ $(id -u) == 0 ]]
then
	${install_command}
elif which sudo > /dev/null
then
	sudo -- sh -c "${install_command}"
else
	echo "Unable to elevate to root. Please install ${packages}."
fi
