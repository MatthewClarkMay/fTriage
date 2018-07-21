#!/bin/bash

if [ -f "../conf/ftriage.conf" ]; then
    source ../conf/ftriage.conf
else
    echo "../conf/ftriage.conf missing - exiting..."
    exit 1
fi

# If sorter OUTDIR does not exist, create it - else, continue 
if [ ! -d "$OUTDIR/carving/sorter" ]; then
    echo "$OUTDIR/carving/sorter does not exist - creating it now..."
    mkdir -p $OUTDIR/carving/sorter
else
    echo "Directory $OUTDIR/carving/sorter already exists - moving on..."
fi

# If sorter OUTDIR is not empty, inform user and exit
if [ "$(ls -A $OUTDIR'/carving/sorter')" ]; then
    echo "Directory $OUTDIR/carving/sorter is not empty, clear it out before filling it up - moving on for now..."
    #exit 1
else
    echo "$OUTDIR/carving/sorter is empty - let's fill it up!"
    echo "Running sorter now using $WHITE_HASH_IDX"
    if [ -f "$WHITE_HASH_IDX" ]; then
        sorter -U -s -m C: -x $WHITE_HASH_IDX -d $OUTDIR/carving/sorter -C $SORTER_CONF $DISKPATH
    else
        echo "$WHITE_HASH_IDX does not exist - exiting now..."
        exit 1 
    fi
fi

#if [ -f "$OUTDIR/carving/sorter/audit.txt" ]; then
#    echo ""
#    egrep '(FILES EXTRACTED|:=)' $OUTDIR/carving/foremost_unallocated/audit.txt
#else
#    echo "File $OUTDIR/carving/foremost_unallocated/audit.txt does not exist..."
#fi
