#!/usr/bin/env bash

# SSH
SSH_ENV=$HOME/.ssh/environment

function start_agent {
    # kill all existing ssh-agent
    killall ssh-agent 2>&1 > /dev/null

    # spawn ssh-agent
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"

    # set correct permissions
    chmod 600 "${SSH_ENV}"

    # get all variables from the environment file
    . "${SSH_ENV}" > /dev/null

    /usr/bin/ssh-add $HOME/.ssh/*_rsa
}

if [[ -f "${SSH_ENV}" ]]; then
    . "${SSH_ENV}" > /dev/null
fi

