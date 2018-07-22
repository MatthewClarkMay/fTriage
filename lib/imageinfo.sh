#!/bin/bash

if [ $# -ne 1 ] || [ ! -f $1 ]; then
    echo "ERROR - usage: $0 /path/to/ftriage.conf"
    exit 1
else
    source $1
fi

if [ -f $MEMPATH ]; then
    vol.py -f $MEMPATH imageinfo
else
    echo "$MEMPATH missing, or not a valid memory image - exiting..."
fi
