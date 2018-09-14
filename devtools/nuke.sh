#!/bin/bash 

# Author:
# Matt May <mcmay.web@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License.  You may obtain a
# copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
# License for the specific language governing permissions and limitations
# under the License.

if [ $# -ne 1 ] || [ ! -f $1 ]; then
    echo "ERROR - usage: $0 ftriage.conf"
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
