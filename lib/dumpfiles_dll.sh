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

# If volatility/dumpfiles_dll OUTDIR does not exist, create it - else, continue
if [ ! -d "$OUTDIR/carving/volatility/dumpfiles_dll" ]; then
    echo "Directory $OUTDIR/carving/volatility/dumpfiles_dll/ does not exist - creating it now..."
    mkdir -p $OUTDIR/carving/volatility/dumpfiles_dll
else
    echo "Directory $OUTDIR/carving/volatility/dumpfiles_dll/ already exists - moving on..."
fi

# If volatility/dumpfiles_dll OUTDIR is not empty, inform user and continue - else, dump DLLs
if [ "$(ls -A $OUTDIR'/carving/volatility/dumpfiles_dll')" ]; then
    echo "Directory $OUTDIR/carving/volatility/dumpfiles_dll not empty - moving on for now..."
else
    echo "Directory $OUTDIR/carving/volatility/dumpfiles_dll is empty - let's fill it up!"
    echo "Carving DLLs..."
    vol.py --profile=$PROFILE -f $MEMPATH dumpfiles -n -i -r \\.dll --dump-dir=$OUTDIR/carving/volatility/dumpfiles_dll | tee $OUTDIR/carving/volatility/dumpfiles_dll_audit.txt
fi
