#!/bin/bash

if [ -f "./settings.conf" ]; then
    source ./settings.conf
else
    echo "./settings.conf missing - exiting..."
    exit 1
fi

vol.py -f $MEMPATH imageinfo
