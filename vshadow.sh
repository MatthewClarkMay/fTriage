#!/bin/bash

if [ -f "./settings.conf" ]; then
    source ./settings.conf
else
    echo "./settings.conf missing - exiting..."
    exit 1
fi


# If $OUTDIR/carving/vshadow does not exist, create it - else, continue 
if [ ! -d "$OUTDIR/carving/vshadow" ]; then
    echo "Directory $OUTDIR/carving/vshadow/ does not exist - creating it now..."
    mkdir -p $OUTDIR/carving/vshadow
else
    echo "Directory $OUTDIR/carving/vshadow/ already exists - moving on..."
fi

# if $OUTDIR/carving/vshadow/vshadowinfo.txt already exists, move on - else, create it
if [ -f "$OUTDIR/carving/vshadow/vshadowinfo.txt" ]; then
    echo "File $OUTDIR/carving/vshadow/vshadowinfo.txt already exists - moving on..."
else
    echo "Running vshadowinfo against $DISKPATH"
    vshadowinfo $DISKPATH | tee $OUTDIR/carving/vshadow/vshadowinfo.txt
fi
