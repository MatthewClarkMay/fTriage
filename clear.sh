#!/bin/bash 

if [ -f "./settings.conf" ]; then
    source ./settings.conf
else
    echo "./settings.conf missing - exiting..."
    exit 1
fi

#rm -rf $OUTDIR
#rm -rf $OUTDIR/carving/foremost
#rm -rf $OUTDIR/carving/volatility
#rm -rf $OUTDIR/carving/volatility/*dump*
#rm -rf $OUTDIR/carving/volatility/dumpfiles_exe
#rm -rf $OUTDIR/carving/volatility/dumpfiles_dll
#rm -rf $OUTDIR/carving/volatility/dlldump
#rm -rf $OUTDIR/carving/*strings*
rm -rf $OUTDIR/carving/carved_hashlists
rm -rf $OUTDIR/carving/vshadow
#rm -rf $OUTDIR/carving/sorter
rm -rf $OUTDIR/timeline
