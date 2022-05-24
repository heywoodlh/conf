#!/usr/bin/env bash

if ! which brew > /dev/null
then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

packages="bash fzf jq git python3 curl mosh gnupg pass ripgrep vim zsh cliclick tmux lima"

if which brew > /dev/null
then
	brew install ${packages}
else
	echo 'Unable to install brew automatically, please install manually'
fi
