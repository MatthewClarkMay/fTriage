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

# If sorter OUTDIR does not exist, create it - else, continue 
if [ ! -d "$OUTDIR/carving/sorter" ]; then
    echo "$OUTDIR/carving/sorter does not exist - creating it now..."
    mkdir -p $OUTDIR/carving/sorter
else
    echo "Directory $OUTDIR/carving/sorter already exists - moving on..."
fi

# If sorter OUTDIR is not empty, inform user and exit
if [ "$(ls -A $OUTDIR'/carving/sorter')" ]; then
    echo "Directory $OUTDIR/carving/sorter is not empty, clear it out before filling it up - moving on for now..."
    exit 1
else
    echo "$OUTDIR/carving/sorter is empty - let's fill it up!"
    echo "Running sorter now using $WHITE_HASH_IDX"
    if [ -f "$WHITE_HASH_IDX" ]; then
        sorter -U -s -m C: -x $WHITE_HASH_IDX -d $OUTDIR/carving/sorter -C $SORTER_CONF $DISKPATH
    else
        echo "$WHITE_HASH_IDX does not exist - exiting now..."
        exit 1 
    fi
fi
