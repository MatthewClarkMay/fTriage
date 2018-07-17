#!/bin/bash

if [ -f "./settings.conf" ]; then
    source ./settings.conf
else
    echo "./settings.conf missing - exiting..."
    exit 1
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
    echo "Directory $OUTDIR/carving/volatility/ not empty - moving on..."
    #exit 1
else
    echo "Directory $OUTDIR/carving/volatility/ is empty - let's fill it up!"
fi

# If volatility/filescan OUTDIR does not exist, create it - else, continue
#if [ ! -d "$OUTDIR/carving/volatility/filescan" ]; then
#    echo "Directory $OUTDIR/carving/volatility/filescan/ does not exist - creating it now..."
#    mkdir -p $OUTDIR/carving/volatility/filescan
#else
#    echo "Directory $OUTDIR/carving/volatility/filescan already exists - moving on..."
#fi

if [ -f "$OUTDIR/carving/volatility/filescan_audit.txt" ]; then
    echo "filescan_audit.txt already exists - exiting now..."
    exit 1
else
    echo "filescan_audit.txt not detected - creating now..."
    vol.py --profile=$PROFILE -f $MEMPATH  filescan | tee $OUTDIR/carving/volatility/filescan_audit.txt
fi

