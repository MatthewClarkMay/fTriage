#!/bin/bash

if [ -f "./settings.conf" ]; then
    source ./settings.conf
else
    echo "./settings.conf missing - exiting..."
    exit 1
fi

# If directory $OUTDIR/carving/carved_hashlists does not exist, create it - else, continue
if [ ! -d "$OUTDIR/carving/carved_hashlists" ]; then
    echo "$OUTDIR/carving/carved_hashlists/ does not exist - creating it now..."
    mkdir -p $OUTDIR/carving/carved_hashlists
else
    echo "Directory $OUTDIR/carving/carved_hashlists/ already exists - moving on..."
fi

# If directory $OUTDIR/carving/carved_hashlists is not empty, inform user and exit - else, continue
if [ "$(ls -A $OUTDIR'/carving/carved_hashlists')" ]; then
    echo "Directory $OUTDIR/carving/carved_hashlists/ is not empty, clear it out before filling it up - exiting for now..."
    exit 1
else
    echo "Directory $OUTDIR/carving/carved_hashlists/ is empty, let's fill it up!"
fi

# If directory $OUTDIR/carving/foremost_unallocated exists and contains directories, hash their contents - else, continue
if [ -d "$OUTDIR/carving/foremost_unallocated" ] && [ "$(ls -A $OUTDIR'/carving/foremost_unallocated')" ]; then
    echo "Directory $OUTDIR/carving/foremost_unallocated/ exists and is not empty - hashing directory contents"

    for dir in $OUTDIR/carving/foremost_unallocated/*; do
        if [ -d "$dir" ]; then
            echo "Running md5sum against $dir"
            md5sum $dir/* >> $OUTDIR/carving/carved_hashlists/foremost_unallocated_hashlist.txt
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
            md5sum $dir/* >> $OUTDIR/carving/carved_hashlists/foremost_slack_hashlist.txt
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
            md5sum $dir/* >> $OUTDIR/carving/carved_hashlists/volatility_hashlist.txt
        fi
    done

else
    echo "Directory $OUTDIR/carving/volatility/ does not exist or is empty - moving on..."
fi
