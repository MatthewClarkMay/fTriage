#!/bin/bash

if [ -f "./rds_modernm/NSRLFile.txt" ]; then
    echo "Running hfind against ./rds_modernm/NSRLFile.txt..."
    hfind -i nsrl-md5 ./rds_modernm/NSRLFile.txt
else
    echo "./rds_modernm/NSRLFile.txt does not exist - exiting..."
    exit 1
fi
