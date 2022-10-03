#!/usr/bin/env bash

packages="curl git bash fzf vim tmux pass rofi gnupg xclip"
brew_packages="coreutils fzf curl gnupg pass pass-otp ripgrep vim tmux python mosh jailkit lima"

supported="false"
## Check if Debian-based OS
if [ -f /etc/debian_version ]
then
	debian='true'
	supported='true'
	packages="${packages} "
	install_command="apt-get update && apt-get install --no-install-recommends -y ${packages}"
fi

## Check if Arch-based OS
if grep -iq 'Arch Linux' /etc/os-release
then
	arch_linux='true'
	supported='true'
	packages="${packages} pass-otp"
	install_command="pacman -Sy --noconfirm ${packages}"
fi

## Check if Alpine-based OS
if grep -iq 'Alpine Linux' /etc/os-release
then
	alpine='true'
	supported='true'
	packages="${packages} pass-otp"
	install_command="apk --no-cache add ${packages}"
fi

## Check if RHEL based OS
if grep -iq 'redhat' /etc/os-release || grep -iq 'fedora' /etc/os-release
then
	rhel='true'
	supported='true'
	packages="${packages} pass-otp"
	install_command="dnf install -y ${packages}"
fi

if [[ ${supported} == 'true' ]]
then
	if [[ $(id -u) == 0 ]]
	then
		${install_command}
	elif which sudo > /dev/null
	then
	        ## Standard installed packages
		sudo -- bash -c "${install_command}"
		## Homebrew installed packages
		if [[ -z ${SKIP_HOMEBREW_INSTALL} ]]
		then
			test -d ~/.linuxbrew || git clone https://github.com/Homebrew/brew ~/.linuxbrew
			test -d ~/.linuxbrew/Library/Taps/homebrew/homebrew-core || git clone --depth=1 https://github.com/homebrew/homebrew-core ~/.linuxbrew/Library/Taps/homebrew/homebrew-core
			test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
			test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
			HOMEBREW_NO_AUTO_UPDATE=1 brew install ${brew_packages}
		fi
	else
		echo "Unable to elevate to root. Please install ${packages}."
	fi
else
	echo 'This distribution is not supported, will not attempt to install packages'
fi

