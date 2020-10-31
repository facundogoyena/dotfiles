#!/usr/bin/env bash

# trap exit to avoid keeping the user in another
# directory if script fails or gets cancelled
ORIGINAL_DIR=$(pwd)

function exit_trap {
    cd $ORIGINAL_DIR
}

set -e
trap exit_trap EXIT

display_usage() {
    echo "This script will compile all config files that needs to be combined for OS specific settings."
    echo "Output files will be generated with the same name and .compiled extension."

    echo -e "\nUsage: $0 [arguments]"

    echo -e "\nArguments:\n   -h  or  --help: Displays this help text."
}

# help
if [[ ($1 == "--help") || $1 == "-h" ]]
then
    display_usage
    exit 0
fi

# switch to this script's directory
SCRIPT_DIR="$(cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P)"
cd $SCRIPT_DIR

# get .env vars
if [ -f ".env" ]; then
    source .env
fi

# sh options
shopt -s globstar
shopt -s nullglob
shopt -s nocaseglob

# clear all compiled files
find . -type f -name "*.compiled" -delete

# determine all files to combine
for file in **/*-{win,unix,osx}; do
    basefile="${file%-[win,unix,osx]*}"
    outputfile="$file.compiled"

    if [ ! -f $basefile ]; then
        cat $file > $outputfile
    else
        cat $basefile $file > $outputfile
    fi

    sed -i "s/\#REPLACE_WIN_HOME\#/$WIN_HOME_REPLACE/" $outputfile
done

# go back to original dir
cd $ORIGINAL_DIR

