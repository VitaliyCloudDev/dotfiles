#!/bin/sh
echo 'Installing dotfiles...'

mkdir -p ~/.config/nvim/

mv init.lua ~/.config/nvim/init.lua
mv vimrc ~/.vimrc

echo 'Done.'