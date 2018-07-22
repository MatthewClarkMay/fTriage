#!/bin/bash

if [ $# -ne 1 ] || [ ! -f $1 ]; then
    echo "ERROR - usage: $0 /path/to/ftriage.conf"
    exit 1
else
    source $1
fi

# If $OUTDIR/carving/reduced_exes/ does not exist, create it - else, continue 
if [ ! -d "$OUTDIR/carving/reduced_exes" ]; then
    echo "Directory $OUTDIR/carving/reduced_exes does not exist - creating it now..."
    mkdir -p $OUTDIR/carving/reduced_exes
else
    echo ""
    echo "Directory $OUTDIR/carving/reduced_exes/ already exists - moving on..."
fi

# If $OUTDIR/carving/reduced_exes/ not empty, inform user and exit - else,
if [ "$(ls -A $OUTDIR'/carving/reduced_exes')" ]; then
    echo "Directory $OUTDIR/carving/reduced_exes/ is not empty, clear it out before filling it up - exiting now..."
    exit 1
else
    echo "$OUTDIR/carving/reduced_exes/ is empty - let's fill it up!"
fi

# If $OUTDIR/carving/sorter/ exists, move carved files to reduced_exes
if [ ! -d "$OUTDIR/carving/sorter" ]; then
    echo "Directory $OUTDIR/carving/sorter does not exist - moving on..."
else
    for dir in $OUTDIR/carving/sorter/*; do
        if [ -d "$dir" ]; then
            echo "Copying files from $dir to $OUTDIR/carving/reduced_exes/"
            cp $dir/* $OUTDIR/carving/reduced_exes
        fi
    done;
fi

# If $OUTDIR/carving/foremost_unallocated/ exists, move carved files to reduced_exes
if [ ! -d "$OUTDIR/carving/foremost_unallocated" ]; then
    echo "Directory $OUTDIR/carving/foremost_unallocated/ does not exist - moving on..."
else
    for dir in $OUTDIR/carving/foremost_unallocated/*; do
        if [ -d "$dir" ]; then
            echo "Copying files from $dir to $OUTDIR/carving/reduced_exes/"
            cp $dir/* $OUTDIR/carving/reduced_exes
        fi
    done;
fi

# If $OUTDIR/carving/foremost_slack/ exists, move carved files to reduced_exes
if [ ! -d "$OUTDIR/carving/foremost_slack" ]; then
    echo "Directory $OUTDIR/carving/foremost_slack/ does not exist - moving on..."
else
    for dir in $OUTDIR/carving/foremost_slack/*; do
        if [ -d "$dir" ]; then
            echo "Copying files from $dir to $OUTDIR/carving/reduced_exes/"
            cp $dir/* $OUTDIR/carving/reduced_exes
        fi
    done;
fi

# If $OUTDIR/carving/volatility/dlldump exists, move carved files to reduced_exes
if [ ! -d "$OUTDIR/carving/volatility/dlldump" ]; then
    echo "Directory $OUTDIR/carving/volatility/dlldump/ does not exist - moving on..."
else
    echo "Copying files from $OUTDIR/carving/volatility/dlldump/ to $OUTDIR/carving/reduced_exes"
    cp $OUTDIR/carving/volatility/dlldump/* $OUTDIR/carving/reduced_exes
fi

# If $OUTDIR/carving/volatility/dumpfiles_dll exists, move carved files to reduced_exes
if [ ! -d "$OUTDIR/carving/volatility/dumpfiles_dll" ]; then
    echo "Directory $OUTDIR/carving/volatility/dumpfiles_dll/ does not exist - moving on..."
else
    echo "Copying files from $OUTDIR/carving/volatility/dumpfiles_dll/ to $OUTDIR/carving/reduced_exes"
    cp $OUTDIR/carving/volatility/dumpfiles_dll/* $OUTDIR/carving/reduced_exes
fi

# If $OUTDIR/carving/volatility/dumpfiles_exe exists, move carved files to reduced_exes
if [ ! -d "$OUTDIR/carving/volatility/dumpfiles_exe" ]; then
    echo "Directory $OUTDIR/carving/volatility/dumpfiles_exe/ does not exist - moving on..."
else
    echo "Copying files from $OUTDIR/carving/volatility/dumpfiles_exe/ to $OUTDIR/carving/reduced_exes"
    cp $OUTDIR/carving/volatility/dumpfiles_exe/* $OUTDIR/carving/reduced_exes
fi
