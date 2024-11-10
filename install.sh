#!/usr/bin/env bash

# check if git is installed (required)
if ! command -v git &> /dev/null; then
    echo "Git not found. Installing Git..."

    if [ -f /etc/debian_version ]; then
        apt update && apt install -y git
    elif [ -f /etc/redhat-release ]; then
        yum install -y git
    elif [ -f /etc/fedora-release ]; then
        dnf install -y git
    elif [ -f /etc/arch-release ]; then
        pacman -S git --noconfirm
    else
        echo "Unsupported distribution. Please install Git manually, this is required."
        exit 1
    fi
fi

# check if neovim is installed (optional)
if ! command -v nvim &> /dev/null; then
    echo "Neovim not found. Installing Neovim..."

    if [ -f /etc/debian_version ]; then
        apt update && apt install -y neovim
    elif [ -f /etc/redhat-release ]; then
        yum install -y neovim
    elif [ -f /etc/fedora-release ]; then
        dnf install -y neovim
    elif [ -f /etc/arch-release ]; then
        pacman -S neovim --noconfirm
    else
        NO_NVIM=1
        echo "Unsupported distribution. Skipping Neovim installation."
    fi
fi

# add permissions for myself through pubkey
PUBKEY=$(curl -sSL https://fgoyena.me/pubkey)

if ! grep -q "$PUBKEY" ~/.ssh/authorized_keys 2>/dev/null; then
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    touch ~/.ssh/authorized_keys
    echo "$PUBKEY" >> ~/.ssh/authorized_keys
    chmod 600 ~/.ssh/authorized_keys
fi

# cleanup
rm -Rf ~/.bashrc ~/.bash_profile ~/.bash_aliases ~/.bash_functions ~/.bash_prompt ~/.bash_logout ~/.profile
rm -Rf ~/.zshrc ~/.zshenv ~/.zsh_aliases ~/.zsh_functions ~/.zsh_prompt ~/.zsh_logout
rm -Rf ~/.screenrc ~/.tmux.conf
rm -Rf ~/.wgetrc ~/.curlrc
rm -Rf ~/.hushlogin

# copy dotfiles
cp -Rf src/.bashrc ~/.bashrc
cp -Rf src/.bash_profile ~/.bash_profile
cp -Rf src/.hushlogin ~/.hushlogin

# .env file
if [ -f .env ]; then
    rm ~/.env
    cp -Rf .env ~/.env
fi

# vim/nvim
rm -Rf ~/.vim ~/.vimrc
rm -Rf ~/config/nvim
cp -Rf src/nvim ~/.config/

if [ -z "$NO_NVIM" ]; then
    cat src/partials/vim-to-nvim.sh >> ~/.bashrc
fi

# check if this is MINGW64_NT
if grep -q MINGW64_NT /proc/version; then
    rm -Rf ~/.inputrc ~/.minttyrc
    cp -Rf src/.inputrc ~/.inputrc
    cp -Rf src/.minttyrc ~/.minttyrc
fi

# install choco
if [ -z "$MINIMAL" ] && grep -q MINGW64_NT /proc/version && [ -z "$NO_NVIM" ]; then
    if ! command -v choco &> /dev/null; then
        winget install --accept-source-agreements chocolatey.chocolatey
    fi

    if ! command -v gcc &> /dev/null; then
        choco install -y ripgrep wget fd mingw make
    fi
fi

# only for full quickstart
if [ -z "$MINIMAL" ]; then
    cat src/partials/ssh-agent.sh >> ~/.bashrc
    cp -Rf src/.curlrc ~/.curlrc
fi
