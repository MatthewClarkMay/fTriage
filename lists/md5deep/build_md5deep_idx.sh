#!/bin/bash

if [ -f "./md5deep.txt" ]; then
    echo "Running hfind against ./md5deep.txt..."
    hfind -i md5sum ./md5deep.txt
else
    echo "./md5deep.txt does not exist - exiting..."
    exit 1
fi
