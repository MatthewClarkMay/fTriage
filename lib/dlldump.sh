#!/bin/bash

if [ $# -ne 1 ] || [ ! -f $1 ]; then
    echo "ERROR - usage: $0 ftriage.conf"
    exit 1
else
    source $1
fi

# If $OUTDIR/volatility/dlldump OUTDIR does not exist, create it - else, continue
if [ ! -d "$OUTDIR/carving/volatility/dlldump" ]; then
    echo "Directory $OUTDIR/carving/volatility/dlldump/ does not exist - creating it now..."
    mkdir -p $OUTDIR/carving/volatility/dlldump
else
    echo "Directory $OUTDIR/carving/volatility/dlldump/ already exists - moving on..."
fi

# If volatility/dlldump OUTDIR is not empty, inform user and continue - else, dump DLLs
if [ "$(ls -A $OUTDIR'/carving/volatility/dlldump')" ]; then
    echo "Directory $OUTDIR/carving/volatility/dlldump not empty - exiting..."
else
    echo "Directory $OUTDIR/carving/volatility/dlldump is empty - let's fill it up!"
    echo "Carving DLLs..."
    vol.py --profile=$PROFILE -f $MEMPATH dlldump --dump-dir=$OUTDIR/carving/volatility/dlldump | tee $OUTDIR/carving/volatility/dlldump_audit.txt
fi

