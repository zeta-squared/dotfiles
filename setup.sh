#!/bin/bash

HOMEBREW = /home/linuxbrew/.linuxbrew/bin/brew
echo "Setup bash user profile"
cp -f .bashrc $HOME
source $HOME/.bashrc

# Check if setup is being performed on a linux container on arm64 hardware (i.e Apple Silicon for work
# machine).
if [[ ${uname -m} == "aarch64" ]] then
    echo "Installing for arm64 MacOS hardware..."
    HOMEBREW_ON_MACOS = 1
    # /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
    sudo mkdir -p /opt/homebrew
    sudo mv /home/linuxbrew/.linuxbrew/* /opt/homebrew/
    echo >> $HOME/.bashrc
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.bashrc
    eval "$(/opt/homebrew/bin/brew shellenv)"
    HOMEBREW = /opt/homebrew/bin/brew
fi

packages=(
    ripgrep
    fzf
    gh
    lazygit
)

for package in "${packages[@]}"; do
    echo "Installing $package..."
    ${HOMEBREW} install "$package"
done

echo "All packages from the setup script have been installed."

echo "Installing dotfiles..."
mkdir -p $HOME/.local/share/nvim
mkdir -p $HOME/.config/nvim
cp -r -t $HOME/.local/share/nvim nvim/UltiSnips nvim/spell
cp -r -t $HOME/.config/nvim nvim/lua nvim/ftplugin nvim/init.lua
cp nvim/pycodestyle $HOME/.config
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
