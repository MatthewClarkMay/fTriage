#!/bin/bash 

if [ -f "./settings.conf" ]; then
    source ./settings.conf
else
    echo "./settings.conf missing - exiting..."
    exit 1
fi

rm -rf $OUTDIR
#rm -rf $OUTDIR/carving/foremost
