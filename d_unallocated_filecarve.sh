#!/bin/bash

if [ -f "./settings.conf" ]; then
    source ./settings.conf
else
    echo "./settings.conf missing - exiting..."
    exit 1
fi

# If foremost_unallocated OUTDIR does not exist, create it - else, continue 
if [ ! -d "$OUTDIR/carving/foremost_unallocated" ]; then
    echo "$OUTDIR/carving/foremost_unallocated does not exist - creating it now..."
    mkdir -p $OUTDIR/carving/foremost_unallocated
else
    echo "Directory $OUTDIR/carving/foremost_unallocated already exists - moving on..."
fi

# If blkls.unallocated dump does not exist, create it - else, continue
if [ ! -f "$OUTDIR/carving/$HOSTNAME.blkls.unallocated" ]; then
    echo 'Dumping unallocated space...'
    blkls $DISKPATH > $OUTDIR/carving/$HOSTNAME.blkls.unallocated
else
    echo "File $OUTDIR/carving/$HOSTNAME.blkls.unallocated already exists - moving on..."
fi    

# If foremost OUTDIR is not empty, inform user and exit
if [ "$(ls -A $OUTDIR'/carving/foremost_unallocated')" ]; then
    echo "Directory $OUTDIR/carving/foremost_unallocated is not empty, clear it out before filling it up - moving on for now..."
    #exit 1
else
    echo "$OUTDIR/carving/foremost_unallocated is empty - let's fill it up!"
    echo 'Carving files from unallocated space...'

    foremost -q -o $OUTDIR/carving/foremost_unallocated -c $FOREMOST_CONF $OUTDIR/carving/$HOSTNAME.blkls.unallocated
    #foremost -q -o $OUTDIR/carving/foremost $OUTDIR/carving/$HOSTNAME.blkls
    #foremost -q -b 4096 -o $OUTDIR/carving/foremost -c /usr/local/etc/foremost.conf $OUTDIR/carving/$HOSTNAME.blkls
fi

if [ -f "$OUTDIR/carving/foremost_unallocated/audit.txt" ]; then
    echo ""
    egrep '(FILES EXTRACTED|:=)' $OUTDIR/carving/foremost_unallocated/audit.txt
else
    echo "File $OUTDIR/carving/foremost_unallocated/audit.txt does not exist..."
fi

# If tsk OUTDIR does not exist, create it - else, continue 
if [ ! -d "$OUTDIR/carving/tsk" ]; then
    echo "$OUTDIR/carving/tsk does not exist - creating it now..."
    mkdir -p $OUTDIR/carving/tsk
else
    echo "Directory $OUTDIR/carving/tsk/ already exists - moving on..."
fi

# If tsk OUTDIR is not empty, inform user and exit
if [ "$(ls -A $OUTDIR'/carving/tsk')" ]; then
    echo "Directory $OUTDIR/carving/tsk/ is not empty, clear it out before filling it up - moving on for now..."
    #exit 1
else
    echo "$OUTDIR/carving/tsk/ is empty - let's fill it up!"
    echo 'Carving files unallocated files using tsk_recover...'
    tsk_recover $DISKPATH $OUTDIR/carving/tsk
fi

