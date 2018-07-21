#!/bin/bash

if [ -f "../conf/ftriage.conf" ]; then
    source ../conf/ftriage.conf
else
    echo "../conf/ftriage.conf missing - exiting..."
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
    echo "Directory $OUTDIR/carving/volatility/ not empty - moving on for now..."
    #exit 1
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

# If volatility/dumpfiles_dll OUTDIR does not exist, create it - else, continue
if [ ! -d "$OUTDIR/carving/volatility/dumpfiles_dll" ]; then
    echo "Directory $OUTDIR/carving/volatility/dumpfiles_dll/ does not exist - creating it now..."
    mkdir -p $OUTDIR/carving/volatility/dumpfiles_dll
else
    echo "Directory $OUTDIR/carving/volatility/dumpfiles_dll/ already exists - moving on..."
fi

# If volatility/dlldump OUTDIR does not exist, create it - else, continue
if [ ! -d "$OUTDIR/carving/volatility/dlldump" ]; then
    echo "Directory $OUTDIR/carving/volatility/dlldump/ does not exist - creating it now..."
    mkdir -p $OUTDIR/carving/volatility/dlldump
else
    echo "Directory $OUTDIR/carving/volatility/dlldump/ already exists - moving on..."
fi

# If volatility/dumpfiles_exe OUTDIR is not empty, inform user and continue - else, dump EXEs
if [ "$(ls -A $OUTDIR'/carving/volatility/dumpfiles_exe')" ]; then
    echo "Directory $OUTDIR/carving/volatility/dumpfiles_exe not empty - moving on for now..."
else
    echo "Directory $OUTDIR/carving/volatility/dumpfiles_exe is empty - let's fill it up!"
    echo 'Carving EXEs...'
    vol.py --profile=$PROFILE -f $MEMPATH dumpfiles -n -i -r \\.exe --dump-dir=$OUTDIR/carving/volatility/dumpfiles_exe | tee $OUTDIR/carving/volatility/dumpfiles_exe_audit.txt
fi

# If volatility/dumpfiles_dll OUTDIR is not empty, inform user and continue - else, dump DLLs
if [ "$(ls -A $OUTDIR'/carving/volatility/dumpfiles_dll')" ]; then
    echo "Directory $OUTDIR/carving/volatility/dumpfiles_dll not empty - moving on for now..."
else
    echo "Directory $OUTDIR/carving/volatility/dumpfiles_dll is empty - let's fill it up!"
    echo 'Carving DLLs...'
    vol.py --profile=$PROFILE -f $MEMPATH dumpfiles -n -i -r \\.dll --dump-dir=$OUTDIR/carving/volatility/dumpfiles_dll | tee $OUTDIR/carving/volatility/dumpfiles_dll_audit.txt
fi

# If volatility/dlldump OUTDIR is not empty, inform user and continue - else, dump DLLs
if [ "$(ls -A $OUTDIR'/carving/volatility/dlldump')" ]; then
    echo "Directory $OUTDIR/carving/volatility/dlldump not empty - moving on for now..."
else
    echo "Directory $OUTDIR/carving/volatility/dlldump is empty - let's fill it up!"
    echo 'Carving DLLs...'
    vol.py --profile=$PROFILE -f $MEMPATH dlldump --dump-dir=$OUTDIR/carving/volatility/dlldump | tee $OUTDIR/carving/volatility/dlldump_audit.txt
fi

