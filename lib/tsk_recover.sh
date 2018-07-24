#!/bin/bash

if [ $# -ne 1 ] || [ ! -f $1 ]; then
    echo "ERROR - usage: $0 ftriage.conf"
    exit 1
else
    source $1
fi

# If tsk_recover OUTDIR does not exist, create it - else, continue 
if [ ! -d "$OUTDIR/carving/tsk_recover" ]; then
    echo "$OUTDIR/carving/tsk_recover does not exist - creating it now..."
    mkdir -p $OUTDIR/carving/tsk_recover
else
    echo ""
    echo "Directory $OUTDIR/carving/tsk_recover/ already exists - moving on..."
fi

# If tsk OUTDIR is not empty, inform user and exit
if [ "$(ls -A $OUTDIR'/carving/tsk_recover')" ]; then
    echo "Directory $OUTDIR/carving/tsk_recover/ is not empty, clear it out before filling it up - exiting now..."
    exit 1
else
    echo "$OUTDIR/carving/tsk_recover/ is empty - let's fill it up!"
    echo "Carving unallocated files using tsk_recover..."
    tsk_recover $DISKPATH $OUTDIR/carving/tsk_recover
fi

