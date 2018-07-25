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

# If tsk_recover OUTDIR does not exist, create it - else, continue 
if [ ! -d "$OUTDIR/carving/tsk_recover" ]; then
    echo "$OUTDIR/carving/tsk_recover does not exist - creating it now..."
    mkdir -p $OUTDIR/carving/tsk_recover
else
    echo ""
    echo "Directory $OUTDIR/carving/tsk_recover/ already exists - moving on..."
fi

# If tsk OUTDIR is not empty, inform user and exit
if [ "$(ls -A $OUTDIR'/carving/tsk_recover')" ]; then
    echo "Directory $OUTDIR/carving/tsk_recover/ is not empty, clear it out before filling it up - exiting now..."
    exit 1
else
    echo "$OUTDIR/carving/tsk_recover/ is empty - let's fill it up!"
    echo "Carving unallocated files using tsk_recover..."
    tsk_recover $DISKPATH $OUTDIR/carving/tsk_recover
fi

