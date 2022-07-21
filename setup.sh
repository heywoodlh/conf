#!/usr/bin/env bash

if [[ -n $1 ]] # values for $1 are 'server', 'workstation'
then
	target="$1"
fi

directory="$(pwd)"

dotfiles="${directory}/dotfiles"
home_files="${directory}/home"
dependencies="${directory}/dependencies"

## Move dotfiles to $HOME/.
for file in ${dotfiles}/*
do
	basename=$(basename ${file})
	filename="${HOME}/.${basename}"
	if [[ -e ${filename} ]]
	then
		mv -v ${filename} ${filename}.orig
	fi
	ln -sv ${file} ${filename}
done

## Move $home_files to $HOME/.
for file in ${home_files}/*
do
	basename=$(basename ${file})
	filename="${HOME}/${basename}"
	if [[ -e ${filename} ]]
	then
		mv -v ${filename} ${filename}.orig
	fi
	ln -sv ${file} ${filename}
done

# If MacOS
if uname | grep -q 'Darwin'
then

	if ! which brew > /dev/null
	then
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"	
	fi

	brew install python@3.10

fi

# If Arch Linux
if grep -q 'Arch Linux' /etc/os-release
then
        sudo pacman -Syu --noconfirm python-pip 
fi

# If Debian-based
if [[ -e /etc/debian_version ]]
then
        sudo apt-get update 
        sudo apt-get install -y python3-pip --no-install-recommends
fi

# If Alpine
if grep -q 'Alpine' /etc/os-release
then
	sudo apk --no-cache add py3-pip
fi


if [[ ${target} == 'workstation' ]]
then
	## Install Linux dependencies
        if uname -a | grep -iq linux
        then
        	${dependencies}/linux/install.sh
        fi
        
        ## Install MacOS dependencies
        if uname -a | grep -iq darwin
        then
        	${dependencies}/darwin/install.sh
        	python3 -m pip install --user -r ${dependencies}/darwin/requirements.txt
        fi
        
        # Install FreeBSD dependencies
        if uname -a | grep -iq freebsd
        then
        	${dependencies}/freebsd/install.sh
        fi
        
        # Install oh-my-zsh
        rm -rf ~/.oh-my-zsh
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        rm ~/.zshrc && ln -s ${dotfiles}/zshrc ~/.zshrc
        rm -rf ~/.oh-my-zsh/custom && ln -s ${dotfiles}/oh-my-zsh/custom ~/.oh-my-zsh/custom
        
        ## Install Python dependencies
        #pip3 install --user -r ${dependencies}/requirements.txt
fi

source ~/.bash_profile

## Sync peru modules
python3 -m pip freeze | grep -q peru || python3 -m pip install --user peru
cd ${directory} && python3 -m peru sync
