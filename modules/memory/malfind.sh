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

# If $OUTDIR/carving/volatility/code_injection does not exist, create it - else, continue 
build_outdir "$OUTDIR/carving/volatility/code_injection"

# if $OUTDIR/carving/volatility/code_injection/malfind_raw.txt already exists, move on - else, create it
if [ -f "$OUTDIR/carving/volatility/code_injection/malfind_raw.txt" ] || [ -d "$OUTDIR/carving/volatility/code_injection/malfind_binaries" ] ; then
    echo "File $OUTDIR/carving/volatility/code_injection/malfind_raw.txt or directory $OUTDIR/carving/volatility/code_injection/malfind_binaries/ already exists - moving on..."
else
    echo "Finding hidden and injected code - Dumping affected memory sections..."
    echo ""
    mkdir $OUTDIR/carving/volatility/code_injection/malfind_binaries
    vol.py --profile=$PROFILE -f $MEMPATH malfind -D $OUTDIR/carving/volatility/code_injection/malfind_binaries > $OUTDIR/carving/volatility/code_injection/malfind_raw.txt 
fi

# if $OUTDIR/carving/volatility/code_injection/malfind_MZ.txt already exists, move on - else, create it
if [ -f "$OUTDIR/carving/volatility/code_injection/malfind_MZ.txt" ]; then
    echo "File $OUTDIR/carving/volatility/code_injection/malfind_MZ.txt already exists - moving on..."
else
    echo ""
    echo "Finding sections where MZ (.EXE header) is present..."
    echo "This could introduce false negatives in cases where MZ is absent..."
    echo ""
    cat $OUTDIR/carving/volatility/code_injection/malfind_raw.txt | egrep -B 4 '^0x.+\sMZ' > $OUTDIR/carving/volatility/code_injection/malfind_MZ.txt
fi

# if $OUTDIR/carving/volatility/code_injection/malfind_raw_unique_pid.txt already exists, move on - else, create it
if [ -f "$OUTDIR/carving/volatility/code_injection/malfind_raw_unique_pid.txt" ]; then
    echo "File $OUTDIR/carving/volatility/code_injection/malfind_raw_unique_pid.txt already exists - moving on..."
else
    echo "Parsing malfind_raw.txt for unique processes to eliminate repeats..."
    echo ""
    cat $OUTDIR/carving/volatility/code_injection/malfind_raw.txt | grep 'Process' | cut -d " " -f2,4 | sort -u > $OUTDIR/carving/volatility/code_injection/malfind_raw_unique_pid.txt
fi

# if $OUTDIR/carving/volatility/code_injection/malfind_MZ_unique_pid.txt already exists, move on - else, create it
if [ -f "$OUTDIR/carving/volatility/code_injection/malfind_MZ_unique_pid.txt" ]; then
    echo "File $OUTDIR/carving/volatility/code_injection/malfind_MZ_unique_pid.txt already exists - moving on..."
else
    echo "Parsing malfind_MZ.txt for unique processes to eliminate repeats..."
    echo ""
    cat $OUTDIR/carving/volatility/code_injection/malfind_MZ.txt | grep 'Process' | cut -d " " -f2,4 | sort -u > $OUTDIR/carving/volatility/code_injection/malfind_MZ_unique_pid.txt
fi
