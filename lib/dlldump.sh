#!/bin/bash

if [ $# -ne 1 ] || [ ! -f $1 ]; then
    echo "ERROR - usage: $0 /path/to/ftriage.conf"
    exit 1
else
    source $1
fi

# If volatility OUTDIR does not exist, create it - else, continue 
if [ ! -d "$OUTDIR/carving/volatility" ]; then
    echo "Directory $OUTDIR/carving/volatility/ does not exist - creating it now..."
    mkdir -p $OUTDIR/carving/volatility
else
    echo "Directory $OUTDIR/carving/volatility/ already exists - moving on..."
fi

# If volatility OUTDIR is not empty, inform user and continue
if [ "$(ls -A $OUTDIR'/carving/volatility')" ]; then
    echo "Directory $OUTDIR/carving/volatility/ not empty - moving on for now..."
else
    echo "Directory $OUTDIR/carving/volatility/ is empty - let's fill it up!"
fi

# If volatility/dlldump OUTDIR does not exist, create it - else, continue
if [ ! -d "$OUTDIR/carving/volatility/dlldump" ]; then
    echo "Directory $OUTDIR/carving/volatility/dlldump/ does not exist - creating it now..."
    mkdir -p $OUTDIR/carving/volatility/dlldump
else
    echo "Directory $OUTDIR/carving/volatility/dlldump/ already exists - moving on..."
fi

# If volatility/dlldump OUTDIR is not empty, inform user and continue - else, dump DLLs
if [ "$(ls -A $OUTDIR'/carving/volatility/dlldump')" ]; then
    echo "Directory $OUTDIR/carving/volatility/dlldump not empty - moving on for now..."
else
    echo "Directory $OUTDIR/carving/volatility/dlldump is empty - let's fill it up!"
    echo 'Carving DLLs...'
    vol.py --profile=$PROFILE -f $MEMPATH dlldump --dump-dir=$OUTDIR/carving/volatility/dlldump | tee $OUTDIR/carving/volatility/dlldump_audit.txt
fi

