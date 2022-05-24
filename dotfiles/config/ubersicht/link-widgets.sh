#!/usr/bin/env bash

mkdir -p ~/.config/ubersicht/widgets

mkdir -p ~/Library/Application\ Support/Übersicht
rm -rf ~/Library/Application\ Support/Übersicht/widgets
ln -s $(realpath ~/.config/ubersicht/widgets) ~/Library/Application\ Support/Übersicht/widgets

