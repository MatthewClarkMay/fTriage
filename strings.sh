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

# if strings_audit.txt already exists, move on - else, create it
if [ -f "$OUTDIR/carving/volatility/strings_audit_sorted.txt" ]; then
    echo "File $OUTDIR/carving/volatility/strings_audit_sorted.txt already exists - moving on..."
else
    echo "Searching for strings...(1)"
    strings -a -t d $MEMPATH > $OUTDIR/carving/volatility/strings_audit.txt
    echo "Searching for strings...(2)"
    strings -a -t d -e l $MEMPATH >> $OUTDIR/carving/volatility/strings_audit.txt
    echo "Sorting strings_audit.txt into strings_audit_sorted.txt"
    sort $OUTDIR/carving/volatility/strings_audit.txt > $OUTDIR/carving/volatility/strings_audit_sorted.txt
fi

if [ -f "$OUTDIR/carving/volatility/strings_audit.txt" ]; then
    rm $OUTDIR/carving/volatility/strings_audit.txt
else
    exit 1
fi
