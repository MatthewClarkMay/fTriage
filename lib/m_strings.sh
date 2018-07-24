#!/bin/bash

if [ $# -ne 1 ] || [ ! -f $1 ]; then
    echo "ERROR - usage: $0 ftriage.conf"
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

# if $OUTDIR/m_strings_audit_sorted.txt already exists, move on - else, create it
if [ -f "$OUTDIR/carving/m_strings_audit_sorted.txt" ]; then
    echo "File $OUTDIR/m_strings_audit_sorted.txt already exists - moving on..."
else
    echo "Searching for strings...(1)"
    strings -a -t d $MEMPATH > $OUTDIR/carving/m_strings_audit.txt
    echo "Searching for strings...(2)"
    strings -a -t d -e l $MEMPATH >> $OUTDIR/carving/m_strings_audit.txt
    echo "Sorting m_strings_audit.txt into m_strings_audit_sorted.txt"
    sort -u $OUTDIR/carving/m_strings_audit.txt > $OUTDIR/carving/m_strings_audit_sorted.txt
fi

if [ -f "$OUTDIR/carving/m_strings_audit.txt" ]; then
    rm $OUTDIR/carving/m_strings_audit.txt
else
    exit 1
fi
