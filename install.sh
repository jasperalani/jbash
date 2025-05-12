#!/usr/bin/env bash

bshrc=/home/develop/.bashrc
# Check if marker is already in ~/.bashrc
if ! grep -q '# --- jbash helper scripts --- #' $bshrc; then
    {
        # add newlines and header for readability
        echo -e
        echo -e
        echo "# --- jbash helper scripts --- #"
        echo ". \"$PWD/echo.sh\""
        echo -e
        echo "# --- end jbash --- #"
    } >> $bshrc
else
    echo "jbash is already installed in $bshrc"
fi

# Reload
echo -e
echo "Please run: source ~/.bashrc"
echo -e

# todo: automatically list and add files in this folder to bashrc