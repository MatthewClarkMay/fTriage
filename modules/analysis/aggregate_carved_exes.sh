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

# If directory $OUTDIR/carving/aggregate_exes does not exist, create it - else, continue
build_outdir "$OUTDIR/carving/aggregate_exes"

# If directory $OUTDIR/carving/aggregate_exes is not empty, inform user and exit - else, continue
if_not_empty_exit_else_continue "$OUTDIR/carving/aggregate_exes"

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
        echo "Directory $METADIR exists - searching sub-directories..."
        for DIR in "${DIRS[@]}"; do
            if [ -d "$METADIR/$DIR" ]; then
                echo "... Copying files from $METADIR/$DIR to $OUTDIR/carving/aggregate_exes"
                cp $METADIR/$DIR/* "$OUTDIR/carving/aggregate_exes"
            fi
        done
    fi
done

fdupes -dN $OUTDIR/carving/aggregate_exes
