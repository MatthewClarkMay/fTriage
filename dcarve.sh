#!/bin/bash

if [ -f "./settings.conf" ]; then
    source ./settings.conf
else
    echo "./settings.conf missing - exiting..."
    exit 1
fi

# If foremost OUTDIR does not exist, create it - else, continue 
if [ ! -d "$OUTDIR/carving/foremost" ]; then
    echo "$OUTDIR/carving/foremost does not exist - creating it now..."
    mkdir -p $OUTDIR/carving/foremost
else
    echo "Directory $OUTDIR/carving/foremost already exists - moving on..."
fi

if [ ! -f "$OUTDIR/carving/$HOSTNAME.blkls" ]; then
    # Add replacement option - for now it will continue
    echo 'Dumping unallocated space - dump slack manually if desired...'
    blkls $DISKPATH > $OUTDIR/carving/$HOSTNAME.blkls
else
    echo "File $OUTDIR/carving/$HOSTNAME.blkls already exists - moving on..."
fi    

# If foremost OUTDIR is not empty, inform user and exit
if [ "$(ls -A $OUTDIR'/carving/foremost')" ]; then
    # Add option for clearing directory
    echo "Directory $OUTDIR/carving/foremost is not empty, clear it out before filling it up - moving on for now..."
    #exit 1
else
    echo "$OUTDIR/carving/foremost is empty - let's fill it up!"
    echo 'Carving Files...'

    foremost -q -o $OUTDIR/carving/foremost -c $FOREMOST_CONF $OUTDIR/carving/$HOSTNAME.blkls
    #foremost -q -o $OUTDIR/carving/foremost $OUTDIR/carving/$HOSTNAME.blkls
    #foremost -q -b 4096 -o $OUTDIR/carving/foremost -c /usr/local/etc/foremost.conf $OUTDIR/carving/$HOSTNAME.blkls
fi

if [ -f "$OUTDIR/carving/foremost/audit.txt" ]; then
    echo ""
    egrep '(FILES EXTRACTED|:=)' $OUTDIR/carving/foremost/audit.txt
else
    echo "File $OUTDIR/carving/foremost/audit.txt does not exist..."
fi
