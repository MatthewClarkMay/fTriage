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

# if $OUTDIR/carving/volatility/code_injection/ldrmodules_raw.txt already exists, move on - else, create it
if [ -f "$OUTDIR/carving/volatility/code_injection/ldrmodules_raw.txt" ] ; then
    echo "File $OUTDIR/carving/volatility/code_injection/ldrmodules_raw.txt already exists - moving on..."
else
    echo "Parsing three separate linked lists for unlinked DLLs..." | tee $OUTDIR/carving/volatility/code_injection/ldrmodules_raw.txt
    printf "InLoadOrderModule (InLoad)\nInInitializationOrderModule (InInit)\nInMemoryOrderModule (InMem)\n\n1. Normal DLLs will display True in each column\n2. Legit entries may be missing from some of the lists - the process EXE will not be present in the InInit list\nIf an entry has no MappedPath information, it generally indicates an injected DLL not present on disk (usually bad)\n\n" | tee -a $OUTDIR/carving/volatility/code_injection/ldrmodules_raw.txt
    printf "Writing output to $OUTDIR/carving/volatility/code_injection/ldrmodules_raw.txt\n\n"
    vol.py --profile=$PROFILE -f $MEMPATH ldrmodules >> $OUTDIR/carving/volatility/code_injection/ldrmodules_raw.txt 
fi

# if $OUTDIR/carving/volatility/code_injection/ldrmodules_raw.txt does not exist, continue - else, parse and report fields showing False 
if [ ! -f "$OUTDIR/carving/volatility/code_injection/ldrmodules_raw.txt" ]; then
    echo "File $OUTDIR/carving/volatility/code_injection/ldrmodules_raw.txt does not exist, moving on..."
else
    echo "Parsing $OUTDIR/carving/volatility/code_injection/ldrmodules_raw.txt for fields reporting False..."
    head -11 $OUTDIR/carving/volatility/code_injection/ldrmodules_raw.txt > $OUTDIR/carving/volatility/code_injection/ldrmodules_reduced.txt
    grep False $OUTDIR/carving/volatility/code_injection/ldrmodules_raw.txt >> $OUTDIR/carving/volatility/code_injection/ldrmodules_reduced.txt
fi

# if $OUTDIR/carving/volatility/code_injection/ldrmodules_verbose_raw.txt already exists, move on - else, create it
if [ -f "$OUTDIR/carving/volatility/code_injection/ldrmodules_verbose_raw.txt" ] ; then
    echo "File $OUTDIR/carving/volatility/code_injection/ldrmodules_verbose_raw.txt already exists - moving on..."
else
    echo "Parsing three separate linked lists for unlinked DLLs..." > $OUTDIR/carving/volatility/code_injection/ldrmodules_verbose_raw.txt
    printf "InLoadOrderModule (InLoad)\nInInitializationOrderModule (InInit)\nInMemoryOrderModule (InMem)\n\n1. Normal DLLs will display True in each column\n2. Legit entries may be missing from some of the lists - the process EXE will not be present in the InInit list\nIf an entry has no MappedPath information, it generally indicates an injected DLL not present on disk (usually bad)\n\n" >> $OUTDIR/carving/volatility/code_injection/ldrmodules_verbose_raw.txt
    printf "Writing output to $OUTDIR/carving/volatility/code_injection/ldrmodules_verbose_raw.txt\n\n"
    vol.py --profile=$PROFILE -f $MEMPATH ldrmodules -v >> $OUTDIR/carving/volatility/code_injection/ldrmodules_verbose_raw.txt
fi

# if $OUTDIR/carving/volatility/code_injection/ldrmodules_verbose_raw.txt does not exist, continue - else, parse and report fields showing False 
#if [ ! -f "$OUTDIR/carving/volatility/code_injection/ldrmodules_verbose_raw.txt" ]; then
#    echo "File $OUTDIR/carving/volatility/code_injection/ldrmodules_verbose_raw.txt does not exist, moving on..."
#else
#    echo "Parsing $OUTDIR/carving/volatility/code_injection/ldrmodules_verbose_raw.txt for fields reporting False..."
#    head -11 $OUTDIR/carving/volatility/code_injection/ldrmodules_verbose_raw.txt > $OUTDIR/carving/volatility/code_injection/ldrmodules_verbose_reduced.txt
#    egrep "(False|Path)" $OUTDIR/carving/volatility/code_injection/ldrmodules_verbose_raw.txt >> $OUTDIR/carving/volatility/code_injection/ldrmodules_verbose_reduced.txt
#fi

