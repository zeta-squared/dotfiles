#!/bin/bash

mkdir -p ~/.local/share/nvim
mkdir -p ~/.config/nvim
cp -r -t ~/.local/share/nvim nvim/Ultisnips nvim/spell
cp -r -t ~/.config/nvim nvim/lua nvim/ftplugin nvim/init.lua
cp nvim/pycodestyle ~/.config

packages=(
    ripgrep
    fzf
    zathura
    gh
    lazygit
)

for package in "${packages[@]}"; do
    echo "Installing $package..."
    brew install "$package"
done

echo "All packages fromt he setup script have been installed."
