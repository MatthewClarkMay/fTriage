#!/bin/bash

if [ -f "../conf/ftriage.conf" ]; then
    source ../conf/ftriage.conf
else
    echo "../conf/ftriage.conf missing - exiting..."
    exit 1
fi

if [ -f $MEMPATH ]; then
    vol.py -f $MEMPATH imageinfo
else
    echo "$MEMPATH missing, or not a valid memory image - exiting..."
fi
