#!/bin/bash

source ./var.conf

# If foremost OUTDIR does not exist, create it - else, continue 
if [ ! -d "$OUTDIR/carving/foremost" ]; then
    echo "$OUTDIR/carving/foremost does not exist - creating it now..."
    mkdir -p $OUTDIR/carving/foremost
else
    echo "Directory $OUTDIR/carving/foremost already exists - moving on..."
fi

# If foremost OUTDIR is not empty, inform user and exit
if [ "$(ls -A $OUTDIR'/carving/foremost')" ]; then
    echo "Directory $OUTDIR/carving/foremost is not empty, clear it out before filling it up..."
    exit 1
    # Add option for clearing directory
else
    echo "$OUTDIR/carving/foremost is empty - let's fill it up!"
fi

if [ -f "$OUTDIR/carving/$HOSTNAME.blkls" ]; then
    # Add replacement option - for now it will force replace
    echo "$OUTDIR/carving/$HOSTNAME.blkls already exists - replacing... (add option?)"
    echo 'Dumping Unallocated Data...'
    blkls $DISKPATH > $OUTDIR/carving/$HOSTNAME.blkls
else
    echo 'Dumping Unallocated Data...'
    blkls $DISKPATH > $OUTDIR/carving/$HOSTNAME.blkls
fi    

echo 'Carving Files...'
foremost -q -o $OUTDIR/carving/foremost -c $FOREMOST_CONF $OUTDIR/carving/foremost/$HOSTNAME.blkls

#foremost -q -b 4096 -o $OUTDIR/carving/foremost -c /usr/local/etc/foremost.conf $OUTDIR/prefetch-carving/$HOSTNAME.blkls

