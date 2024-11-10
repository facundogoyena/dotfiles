#!/usr/bin/env bash

# trap exit to avoid keeping the user in another
# directory if script fails or gets cancelled
ORIGINAL_DIR=$(pwd)

function exit_trap {
    cd $ORIGINAL_DIR
}

set -e
trap exit_trap EXIT

# confirmation
read -p "This will overwrite your existing dotfiles. Are you sure? (y/N) " -n 1

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Exiting..."
    exit 1
fi

# check if minimal version is requested
if [ -z "$MINIMAL" ]; then
    read -p "Would you like to install the minimal version? (y/N) " -n 1

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        MINIMAL=1
    fi
fi

echo -e "\nLet's continue!"

# clone the repository in temporary directory
TMPDIR=$(mktemp -d)
git clone https://github.com/facundogoyena/dotfiles.git $TMPDIR

cd $TMPDIR

# run install script
. install.sh

# go back to original dir
cd $ORIGINAL_DIR

# cleanup
rm -Rf $TMPDIR
