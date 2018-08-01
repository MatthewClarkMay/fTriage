#!/bin/bash

if [ $# -ne 1 ] || [ ! -f $1 ]; then
    echo "ERROR - usage: $0 /path/to/ftriage.conf"
    exit 1
else
    source $1
fi

# If directory $OUTDIR/carving/hashlists does not exist, create it - else, continue
if [ ! -d "$OUTDIR/carving/hashlists" ]; then
    echo "$OUTDIR/carving/hashlists/ does not exist - creating it now..."
    mkdir -p $OUTDIR/carving/hashlists
else
    echo "Directory $OUTDIR/carving/hashlists/ already exists - moving on..."
fi

# If directory $OUTDIR/carving/hashlists is not empty, inform user and exit - else, continue
if [ "$(ls -A $OUTDIR'/carving/hashlists')" ]; then
    echo "Directory $OUTDIR/carving/hashlists/ is not empty, clear it out before filling it up - exiting for now..."
    exit 1
else
    echo "Directory $OUTDIR/carving/hashlists/ is empty, let's fill it up!"
fi

# If directory $OUTDIR/carving/foremost_unallocated exists and contains directories, hash their contents - else, continue
if [ -d "$OUTDIR/carving/foremost_unallocated" ] && [ "$(ls -A $OUTDIR'/carving/foremost_unallocated')" ]; then
    echo "Directory $OUTDIR/carving/foremost_unallocated/ exists and is not empty - hashing directory contents"

    for dir in $OUTDIR/carving/foremost_unallocated/*; do
        if [ -d "$dir" ]; then
            echo "Running md5sum against $dir"
            DIRBASE=$(basename $dir)
            md5sum $dir/* >> $OUTDIR'/carving/hashlists/foremost_unallocated_'$DIRBASE'_hashlist.txt'
        fi
    done

else
    echo "Directory $OUTDIR/carving/foremost_unallocated/ does not exist or is empty - moving on..."
fi

# If directory $OUTDIR/carving/foremost_slack exists and contains directories, hash their contents - else, continue
if [ -d "$OUTDIR/carving/foremost_slack" ] && [ "$(ls -A $OUTDIR'/carving/foremost_slack')" ]; then
    echo "Directory $OUTDIR/carving/foremost_slack/ exists and is not empty - hashing directory contents"

    for dir in $OUTDIR/carving/foremost_slack/*; do
        if [ -d "$dir" ]; then
            echo "Running md5sum against $dir"
            DIRBASE=$(basename $dir)
            md5sum $dir/* >> $OUTDIR'/carving/hashlists/foremost_slack_'$DIRBASE'_hashlist.txt'
        fi
    done

else
    echo "Directory $OUTDIR/carving/foremost_slack/ does not exist or is empty - moving on..."
fi

# If directory $OUTDIR/carving/volatility exists and contains directories, hash their contents - else, continue
if [ -d "$OUTDIR/carving/volatility" ] && [ "$(ls -A $OUTDIR'/carving/volatility')" ]; then
    echo "Directory $OUTDIR/carving/volatility/ exists and is not empty - hashing directory contents"

    for dir in $OUTDIR/carving/volatility/*; do
        if [ -d "$dir" ]; then
            echo "Running md5sum against $dir"
            DIRBASE=$(basename $dir)
            md5sum $dir/* >> $OUTDIR'/carving/hashlists/volatility_'$DIRBASE'_hashlist.txt'
        fi
    done

else
    echo "Directory $OUTDIR/carving/volatility/ does not exist or is empty - moving on..."
fi

# If directory $OUTDIR/carving/tsk_recover exists and contains directories/files, hash their contents - else, continue
if [ -d "$OUTDIR/carving/tsk_recover" ] && [ "$(ls -A $OUTDIR'/carving/tsk_recover')" ]; then
    echo "Directory $OUTDIR/carving/tsk_recover/ exists and is not empty - hashing directory contents"
    echo "Running md5sum against $OUTDIR/carving/tsk_recover/"
    find $OUTDIR/carving/tsk_recover -exec md5sum {} 2>/dev/null \; >> $OUTDIR'/carving/hashlists/tsk_recover_hashlist.txt'
    egrep '(.exe|.dll)' $OUTDIR/carving/hashlists/tsk_recover_hashlist.txt > $OUTDIR/carving/hashlists/tsk_exe_dll_hashlist.txt
else
    echo "Directory $OUTDIR/carving/tsk_recover/ does not exist or is empty - moving on..."
fi

if [ -d "$OUTDIR/carving/reduced_exes" ] && [ "$(ls -A $OUTDIR'/carving/reduced_exes')" ]; then
    echo "Directory $OUTDIR/carving/reduced_exes/ exists and is not empty - hashing directory contents"
    #find $OUTDIR/carving/reduced_exes -exec md5sum {} 2>/dev/null \; >> $OUTDIR'/carving/hashlists/reduced_exes_hashlist.txt'
    echo "Running md5sum against $OUTDIR/carving/reduced_exes/"
    md5sum $OUTDIR/carving/reduced_exes/* >> $OUTDIR'/carving/hashlists/reduced_exes_hashlist.txt'
else
    echo "Directory $OUTDIR/carving/reduced_exes/ does not exist or is empty - moving on..."
fi
