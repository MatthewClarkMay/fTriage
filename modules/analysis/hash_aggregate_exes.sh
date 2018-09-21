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
    echo "ERROR - usage: $0 /path/to/ftriage.conf"
    exit 1
else
    source $1
fi

# If directory $OUTDIR/carving/hashlists does not exist, create it - else, continue
build_outdir "$OUTDIR/carving/hashlists"

# If directory $OUTDIR/carving/hashlists is not empty, inform user and exit - else, continue
if_not_empty_exit_else_continue "$OUTDIR/carving/hashlists"

METADIRS=(
          "$OUTDIR/carving/sorter"
          "$OUTDIR/carving/foremost_unallocated"
          "$OUTDIR/carving/foremost_slack"
          "$OUTDIR/carving/volatility"
         )

DIRS=(
      "exec" #sorter
      "documents" #sorter
      "adobepdf" #sorter
      "exe" #foremost
      "doc" #foremost
      "pdf" #foremost
      "dumpfiles_exe" #dumpfiles
      "dumpfiles_dll" #dumpfiles
      "dlldump" #dlldump
      )

for METADIR in "${METADIRS[@]}"; do
    if [ ! -d "$METADIR" ]; then
        echo "Directory $METADIR does not exist - moving on..."
    else
        echo "Directory $METADIR exists - hashing sub-directories..."
        BNAME=$(basename $METADIR)
        for DIR in "${DIRS[@]}"; do
            if [ -d "$METADIR/$DIR" ]; then
                echo "... Running md5sum against $METADIR/$DIR"
                md5sum $METADIR/$DIR/* >> $OUTDIR'/carving/hashlists/'$BNAME'_'$DIR'_hashlist.txt'
            fi
        done
    fi
done

if [ ! -d "$OUTDIR/carving/aggregate_exes" ] && [ "$(ls -A $OUTDIR'/carving/aggregate_exes')" ]; then
    echo "Directory $OUTDIR/carving/aggregate_exes/ does not exist or is empty - moving on..."
else
    echo "Directory $OUTDIR/carving/aggregate_exes/ exists and is not empty - hashing directory contents..."
    echo "... Running md5sum against $OUTDIR/carving/aggregate_exes/"
    md5sum $OUTDIR/carving/aggregate_exes/* >> $OUTDIR'/carving/hashlists/aggregate_exes_hashlist.txt'
fi

if [ ! -d "$OUTDIR/carving/tsk_recover" ] && [ "$(ls -A $OUTDIR'/carving/tsk_recover')" ]; then
    echo "Directory $OUTDIR/carving/tsk_recover/ does not exist or is empty - moving on..."
else
    echo "Directory $OUTDIR/carving/tsk_recover/ exists and is not empty - hashing directory contents"
    echo "... Running md5sum against $OUTDIR/carving/tsk_recover/"
    find $OUTDIR/carving/tsk_recover -exec md5sum {} 2>/dev/null \; >> $OUTDIR'/carving/hashlists/tsk_recover_full_hashlist.txt'
    egrep '(\.exe|\.dll)' $OUTDIR/carving/hashlists/tsk_recover_full_hashlist.txt > $OUTDIR/carving/hashlists/tsk_recover_exe_dll_hashlist.txt
fi

