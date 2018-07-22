#!/bin/bash

if [ $# -ne 1 ] || [ ! -f $1 ]; then
    echo "ERROR - usage: $0 /path/to/ftriage.conf"
    exit 1
else
    source $1
fi

# If $OUTDIR/carving does not exist, create it - else, continue 
if [ ! -d "$OUTDIR/carving/" ]; then
    echo "Directory $OUTDIR/carving/ does not exist - creating it now..."
    mkdir -p $OUTDIR/carving/
else
    echo "Directory $OUTDIR/carving/ already exists - moving on..."
fi

# if $OUTDIR/d_strings_audit_sorted.txt already exists, move on - else, create it
if [ -f "$OUTDIR/carving/d_strings_audit_sorted.txt" ]; then
    echo "File $OUTDIR/d_strings_audit_sorted.txt already exists - moving on..."
else
    echo "Searching for strings...(1)"
    strings -a -t d $DISKPATH > $OUTDIR/carving/d_strings_audit.txt
    echo "Searching for strings...(2)"
    strings -a -t d -e l $DISKPATH >> $OUTDIR/carving/d_strings_audit.txt
    echo "Sorting d_strings_audit.txt into d_strings_audit_sorted.txt"
    sort -u $OUTDIR/carving/d_strings_audit.txt > $OUTDIR/carving/d_strings_audit_sorted.txt
fi

if [ -f "$OUTDIR/carving/d_strings_audit.txt" ]; then
    rm $OUTDIR/carving/d_strings_audit.txt
else
    exit 1
fi
