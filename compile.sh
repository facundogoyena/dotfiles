#!/usr/bin/env bash

# TODO: merge (probably won't do it)

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

# sh options
shopt -s globstar
shopt -s nullglob
shopt -s nocaseglob

# clear all compiled files
find . -type f -name "*.compiled" -delete

has_warnings=0

# determine all files to combine
for file in **/*-{win,unix,osx}; do
    basefile="${file%-[win,unix,osx]*}"
    outputfile="$file.compiled"

    if [ ! -f $basefile ]; then
        has_warnings=1
        echo "Warning: Base file for $file not found"
        continue
    fi

    cat $basefile $file > $outputfile
done

if [ $has_warnings -eq 1 ]; then
    echo "Completed with warnings"
else
    echo "Completed successfully"
fi

