# dotfiles
if [[ -f "$HOME/.env" ]]; then
    source $HOME/.env
fi

# navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~" # `cd` is probably faster to type though
alias -- -="cd -"

# general
alias l='ls -lah'
alias la='ls -lAh'
alias ll='ls -alF'
alias ls='ls --color=tty'
alias lsa='ls -lah'
alias open='explorer.exe'
alias o='open .'

# git
alias g="git"
alias gaa="git add ."
alias gs="git status"
alias gm="git commit -m \""
alias gpull="git pull"
alias gpush="git push"
alias gfetch="git fetch"
alias gnah="git reset --hard && git clean -df"
alias gprune="git remote prune origin"
alias gc="git checkout"
alias gcb="git checkout -b"
alias gppull="gprune && gpull"

# ip address
alias myip="curl ipinfo.io/ip"
alias getip="myip"

# config
export XDG_CONFIG_HOME="$HOME/.config/"
