#!/bin/bash

HOSTNAME="win7host"
PROFILE=""

DISKPATH="/media/sansforensics/exFat/sager-backup/GCFA-Drive-1/win7-32-nromanoff-10.3.58.5/win7-32-nromanoff-c-drive/win7-32-nromanoff-c-drive.E01"
MEMPATH=""
OUTDIR="/cases/test"

mkdir -p $OUTDIR/carving/foremost

echo 'Dumping Unallocated Data'
blkls $DISKPATH > $OUTDIR/carving/$HOSTNAME.blkls &&

echo 'Carving Files'
foremost -q -o $OUTDIR/carving/foremost -c ./conf/foremost.conf $OUTDIR/carving/$HOSTNAME.blkls

#foremost -q -b 4096 -o $OUTDIR/carving/foremost -c /usr/local/etc/foremost.conf $OUTDIR/prefetch-carving/$HOSTNAME.blkls

