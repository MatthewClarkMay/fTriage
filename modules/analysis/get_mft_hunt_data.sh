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

if [ $# -lt 1 ] || [ $# -gt 3 ] || [ ! -f $1 ] || [ ! -d $2 ]; then
    echo "ERROR - usage: $0 ftriage.conf <_MFT_DIR>"
    exit 1
else
    source $1
fi

build_outdir "$OUTDIR/mft"
#if_not_empty_exit_else_continue "$OUTDIR/mft"

if [ $# -eq 2 ] && [ -d $2 ]; then
    MFTPATH=$(realpath $2)
else
    MFTPATH="$OUTDIR/image_export"
    if [ ! -d $MFTPATH ]; then
        echo "Directory $MFTPATH does not exist - exiting now..."
        exit 1
    fi
fi

echo "Running analyzeMFT.py against $MFTPATH/*_MFT..."

for mft in $MFTPATH/*_MFT; do
    BNAME=$(basename $mft)
    printf "\n$MFTPATH/*_MFT\n"
    analyzeMFT.py -a -p -f $MFTPATH/$BNAME -o $OUTDIR/mft/"$BNAME"-analyzeMFT.csv
done
