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

# If $OUTDIR/carving/volatility/rootkits does not exist, create it - else, continue 
build_outdir "$OUTDIR/carving/volatility/rootkits"

# if $OUTDIR/carving/volatility/rootkits/psxview.txt already exists, move on - else, create and begin automated memory analysis
if [ -f "$OUTDIR/carving/volatility/rootkits/psxview.txt" ]; then
    echo "File $OUTDIR/carving/volatility/rootkits/psxview.txt already exists - moving on..."
else
    echo "Running Volatility psxview plugin..."
    echo ""
    printf "Plugins Run:\n----------\npslist: Read the EPROCESS doubly linked list\npsscan: Scan for EPROCESS structures throughout memory.\nthrdproc: Review all threads found in the memory image and collect processes using the thread parent process identifier.\npspcid: The PsPCid table is yet another kernel object that keeps track of process and thread PIDs.\ncsrss: The csrss.exe process keeps a handle to each process started after it (so there will be no entries for smss.exe, the System process, and csrss.exe).\nsession: List of processes belonging to each logon session.\ndeskthrd: Identify processes via threads attached to each Windows desktop.\n\n" > $OUTDIR/carving/volatility/rootkits/psxview.txt
    vol.py --profile=$PROFILE -f $MEMPATH psxview >> $OUTDIR/carving/volatility/rootkits/psxview.txt
fi
