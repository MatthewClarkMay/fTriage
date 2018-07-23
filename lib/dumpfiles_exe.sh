#!/bin/bash

if [ $# -ne 1 ] || [ ! -f $1 ]; then
    echo "ERROR - usage: $0 /path/to/ftriage.conf"
    exit 1
else
    source $1
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
    echo "Directory $OUTDIR/carving/volatility/ not empty - moving on for now..."
else
    echo "Directory $OUTDIR/carving/volatility/ is empty - let's fill it up!"
fi

# If volatility/dumpfiles_exe OUTDIR does not exist, create it - else, continue
if [ ! -d "$OUTDIR/carving/volatility/dumpfiles_exe" ]; then
    echo "Directory $OUTDIR/carving/volatility/dumpfiles_exe/ does not exist - creating it now..."
    mkdir -p $OUTDIR/carving/volatility/dumpfiles_exe
else
    echo "Directory $OUTDIR/carving/volatility/dumpfiles_exe/ already exists - moving on..."
fi

# If volatility/dumpfiles_exe OUTDIR is not empty, inform user and continue - else, dump EXEs
if [ "$(ls -A $OUTDIR'/carving/volatility/dumpfiles_exe')" ]; then
    echo "Directory $OUTDIR/carving/volatility/dumpfiles_exe not empty - moving on for now..."
else
    echo "Directory $OUTDIR/carving/volatility/dumpfiles_exe is empty - let's fill it up!"
    echo 'Carving EXEs...'
    vol.py --profile=$PROFILE -f $MEMPATH dumpfiles -n -i -r \\.exe --dump-dir=$OUTDIR/carving/volatility/dumpfiles_exe | tee $OUTDIR/carving/volatility/dumpfiles_exe_audit.txt
fi
