#!/bin/bash 

if [ $# -ne 1 ] || [ ! -f $1 ]; then
    echo "ERROR - usage: $0 /path/to/ftriage.conf"
    exit 1
else
    source $1
fi

rm -rf $OUTDIR
rm -rf $OUTDIR/carving/
#rm -rf $OUTDIR/carving/foremost
#rm -rf $OUTDIR/carving/volatility
#rm -rf $OUTDIR/carving/volatility/*dump*
#rm -rf $OUTDIR/carving/volatility/dumpfiles_exe
#rm -rf $OUTDIR/carving/volatility/dumpfiles_dll
#rm -rf $OUTDIR/carving/volatility/dlldump
#rm -rf $OUTDIR/carving/*strings*
#rm -rf $OUTDIR/carving/carved_hashlists
#rm -rf $OUTDIR/carving/vshadow
#rm -rf $OUTDIR/carving/sorter
#rm -rf $OUTDIR/carving/reduced_exes
rm -rf $OUTDIR/timeline
rm -rf $OUTDIR/logs
