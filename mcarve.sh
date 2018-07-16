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

# If volatility OUTDIR is not empty, inform user and exit - else, continue
if [ "$(ls -A $OUTDIR'/carving/volatility')" ]; then
    # Add option for clearing directory
    echo "Directory $OUTDIR/carving/volatility/ not empty, clear it out before filling it up - exiting for now..."
    exit 1
else
    echo "Directory $OUTDIR/carving/volatility/ is empty - let's fill it up!"
fi

# If volatility/exe OUTDIR does not exist, create it - else, continue
if [ ! -d "$OUTDIR/carving/volatility/exe" ]; then
    echo "Directory $OUTDIR/carving/volatility/exe/ does not exist - creating it now..."
    mkdir -p $OUTDIR/carving/volatility/exe
else
    echo "Directory $OUTDIR/carving/volatility/ already exists - moving on..."
fi

# If volatility/dll OUTDIR does not exist, create it - else, continue
if [ ! -d "$OUTDIR/carving/volatility/dll" ]; then
    echo "Directory $OUTDIR/carving/volatility/dll/ does not exist - creating it now..."
    mkdir -p $OUTDIR/carving/volatility/dll
else
    echo "Directory $OUTDIR/carving/volatility/ already exists - moving on..."
fi

#echo 'Carving EXEs...'
#vol.py --profile=$PROFILE -f $MEMPATH dumpfiles -n -i -r \\.exe --dump-dir=$OUTDIR/carving/volatility/exe | tee $OUTDIR/carving/volatility/dumpfiles_exe_audit.txt
echo 'Carving DLLs...'
vol.py --profile=$PROFILE -f $MEMPATH dumpfiles -n -i -r \\.dll --dump-dir=$OUTDIR/carving/volatility/dll | tee $OUTDIR/carving/volatility/dumpfiles_dll_audit.txt
vol.py --profile=$PROFILE -f $MEMPATH dlldump --dump-dir=$OUTDIR/carving/volatility/dll | tee $OUTDIR/carving/volatility/dlldump_audit.txt

