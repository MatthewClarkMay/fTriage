#!/bin/bash

if [ -f "./settings.conf" ]; then
    source ./settings.conf
else
    echo "./settings.conf missing - exiting..."
    exit 1
fi

# If foremost OUTDIR does not exist, create it - else, continue 
if [ ! -d "$OUTDIR/carving/foremost" ]; then
    echo "$OUTDIR/carving/foremost does not exist - run dcarve.sh first..."
    exit 1
else
    echo "Directory $OUTDIR/carving/foremost exists - moving on..."
fi

if "$ls -A $OUTDIR'/carving/foremost')" ]; then
    # parse carved files
else
    echo "$OUTDIR/carving/foremost is empty - nothing to reduce..."
    exit 1
fi

