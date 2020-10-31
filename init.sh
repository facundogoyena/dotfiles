#!/usr/bin/env bash

# trap exit to avoid keeping the user in another
# directory if script fails or gets cancelled
ORIGINAL_DIR=$(pwd)

function exit_trap {
    cd $ORIGINAL_DIR
}

set -e
trap exit_trap EXIT

# determine OS
OS="unknown"

if [[ $(grep Microsoft /proc/version) ]]; then
    OS="win"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="osx"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="unix"
fi

if [[ "$OS" == "unknown" ]]; then
    echo "Unable to determine the OS type. I would advise to do something, but, I don't know, figure it out :), gl!"
    exit 1
fi

# switch to this script's directory
SCRIPT_DIR="$(cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P)"
cd $SCRIPT_DIR

# get .env vars
if [ -f ".env" ]; then
    source .env
fi

# compile
./compile.sh 2>&1 >/dev/null

# helpers
function trydeletefile {
    TARGET=$1

    if [ -f "$TARGET" ]; then
        rm $TARGET 2>/dev/null > /dev/null
    fi
}

function trycreatefolder {
    TARGET=$1
    FOLDER=$(dirname $TARGET)

    if [ ! -d "$FOLDER" ]; then
        mkdir -p $FOLDER
    fi
}

function trycopyfile {
    SOURCE=$1
    TARGET=$2

    trydeletefile $TARGET
    trycreatefolder $TARGET

    cp $SOURCE $TARGET
}

function trylinkfile {
    SOURCE=$1
    TARGET=$2

    trydeletefile $TARGET
    trycreatefolder $TARGET

    ln -s $SOURCE $TARGET
}

# mappings
declare -A mappings

mappings[".vimrc"]="$HOME/.vimrc"
mappings["alacritty.yml"]="$HOME/.config/alacritty/alacritty.yml"

if [[ "$OS" == "win" ]]; then
    declare -A wsl_mappings

    wsl_mappings[".vimrc"]="$WSL_HOME/.vimrc"
    wsl_mappings["alacritty.yml"]="$WSL_HOME/AppData/Roaming/alacritty/alacritty.yml"
fi

# copy/link files
# if running:
#   - under WSL, it will copy files to the windows folder and create links on the linux install
#   - directly on linux/osx, it will create links
for source_file in ${!mappings[@]}; do
    target_file="${mappings[$source_file]}"

    # if running under WSL, we'll need to use other mappings
    if [[ "$OS" == "win" ]]; then
        wsl_source_file=$source_file
        target_wsl_file="${wsl_mappings[$source_file]}"

        if [[ -f "$wsl_source_file-$OS.compiled" ]]; then
            wsl_source_file="$wsl_source_file-$OS.compiled"
        fi

        trycopyfile $SCRIPT_DIR/$wsl_source_file $target_wsl_file
    elif [[ -f "$source_file-$OS.compiled" ]]; then
        source_file="$source_file-$OS.compiled"
    fi

    # standard linux/osx links
    trylinkfile $SCRIPT_DIR/$source_file $target_file
done

# unset helpers and stuff
unset trydeletefile
unset trycreatefolder
unset trycopyfile
unset trylinkfile

# go back to original dir
cd $ORIGINAL_DIR

