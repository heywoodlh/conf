#!/usr/bin/env bash

tmux_home="~/.tmux"

if echo ${SHELL} | grep -q pwsh
then
    tmux source-file ${tmux_home}/pwsh.conf    
fi
