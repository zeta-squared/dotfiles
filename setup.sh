#!/bin/bash

packages=(
    ripgrep
    fzf
    gh
    lazygit
)

for package in "${packages[@]}"; do
    echo "Installing $package..."
    /home/linuxbrew/.linuxbrew/bin/brew install "$package"
done

echo "All packages from the setup script have been installed."

echo "Installing dotfiles..."
mkdir -p $HOME/.local/share/nvim
mkdir -p $HOME/.config/nvim
cp -r -t $HOME/.local/share/nvim nvim/UltiSnips nvim/spell
cp -r -t $HOME/.config/nvim nvim/lua nvim/ftplugin nvim/init.lua
cp nvim/pycodestyle $HOME/.config
cp -f .bashrc $HOME
cp -rf -t $HOME/.config gh lazygit
echo "Dotfiles have been installed."

echo "Installing vim-plug..."
curl -fLo ${XDG_DATA_HOME:-$HOME}/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo "Vim-plug has been installed."

echo "Creating python provider for neovim..."
python3 -m venv $HOME/.local/share/nvim/nvim_venv
source $HOME/.local/share/nvim/nvim_venv/bin/activate
pip install pynvim
deactive
echo "Python provider setup complete."

echo "Running plugin installation in neovim..."
vim -c PlugInstall -c q -c q
echo "Neovim plugins installed."
