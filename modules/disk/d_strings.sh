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

# If $OUTDIR/carving does not exist, create it - else, continue 
build_outdir "$OUTDIR/carving"

# if $OUTDIR/d_strings_sorted.txt already exists, move on - else, create it
if [ -f "$OUTDIR/carving/d_strings_sorted.txt" ]; then
    echo "File $OUTDIR/d_strings_sorted.txt already exists - moving on..."
else
    echo "Searching for strings...(1)"
    strings -a -t d $DISKPATH > $OUTDIR/carving/d_strings.txt
    echo "Searching for strings...(2)"
    strings -a -t d -e l $DISKPATH >> $OUTDIR/carving/d_strings.txt
    echo "Sorting d_strings.txt into d_strings_sorted.txt"
    sort -u $OUTDIR/carving/d_strings.txt > $OUTDIR/carving/d_strings_sorted.txt
fi

if [ -f "$OUTDIR/carving/d_strings.txt" ]; then
    rm $OUTDIR/carving/d_strings.txt
else
    exit 1
fi
