#!/bin/bash

mkdir -p $HOME/.local/share/nvim
mkdir -p $HOME/.config/nvim
cp -r -t $HOME/.local/share/nvim nvim/UltiSnips nvim/spell
cp -r -t $HOME/.config/nvim nvim/lua nvim/ftplugin nvim/init.lua
cp nvim/pycodestyle $HOME/.config

packages=(
    ripgrep
    fzf
    zathura
    gh
    lazygit
)

for package in "${packages[@]}"; do
    echo "Installing $package..."
    /home/linuxbrew/.linuxbrew/bin/brew install "$package"
done

echo "All packages from the setup script have been installed."

cp -f .bashrc $HOME
cp -rf -t $HOME/.config gh lazygit
