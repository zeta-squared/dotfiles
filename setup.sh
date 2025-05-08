#!/bin/bash

DOTFILES_DIR=$(dirname "$(realpath $0)")
HOMEBREW=/home/linuxbrew/.linuxbrew/bin
UNAME_MACHINE="$(/usr/bin/uname -m)"
echo "Setup bash user profile"
cp -f .bashrc $HOME
source $HOME/.bashrc

packages=(
    neovim
    ripgrep
    fzf
    gh
    lazygit
)

echo "Installing homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Check if setup is being performed on a linux container on arm64 hardware (i.e Apple Silicon for work
# machine). This is a temporary work around until there is support for arm64 linux distributions for homebrew
# (see https://github.com/Homebrew/brew/issues/19208).
if [[ ${UNAME_MACHINE} == "aarch64" ]]; then
    echo "Configuring homebrew for arm64..."
    sudo mkdir -p /opt/homebrew
    sudo mv /home/linuxbrew/.linuxbrew/* /opt/homebrew/
    echo >> ${HOME}/.bashrc
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ${HOME}/.bashrc
    eval "$(/opt/homebrew/bin/brew shellenv)"
    HOMEBREW=/opt/homebrew/bin
else
    echo >> ${HOME}/.bashrc
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ${HOME}/.bashrc
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

for package in "${packages[@]}"; do
    echo "Installing $package..."
    ${HOMEBREW}/brew install "$package"
done

echo "All packages from the setup script have been installed."

echo "Installing dotfiles..."
cp -ft ${HOME} ${DOTFILES_DIR}/.bashrc
source ${HOME}/.bashrc
cp -rf ${DOTFILES_DIR}/config/* ${HOME}/.config/
cp -rf ${DOTFILES_DIR}/local/* ${HOME}/.local/
echo "Successfully installed dotfiles."

echo "Installing vim-plug..."
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
echo "Vim-plug has been installed."

echo "Creating python provider for neovim..."
python3 -m venv ${HOME}/.local/share/nvim/nvim_venv
source ${HOME}/.local/share/nvim/nvim_venv/bin/activate
pip install pynvim
deactive
echo "Python provider setup complete."

echo "Running plugin installation in neovim..."
${HOMEBREW}/nvim -c PlugInstall -c q -c q
echo "Neovim plugins installed."
