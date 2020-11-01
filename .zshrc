# ZSH Basics
export ZSH="$HOME/.oh-my-zsh"
export UPDATE_ZSH_DAYS=3

ZSH_THEME="robbyrussell"
plugins=(git)

source $ZSH/oh-my-zsh.sh

# dotfiles
if [[ -f ".env" ]]; then
    source .env
fi

if [[ "$WSL" == "1" ]]; then
    # Fix LS and cd completion colors for WSL
    LS_COLORS="ow=01;36;40" && export LS_COLORS
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi

source ssh-agent.sh
source .aliases
source .functions

