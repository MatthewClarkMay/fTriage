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

# if $OUTDIR/logs/ does not exist, create it - else, continue
if [ ! -d "$OUTDIR/logs" ]; then
    mkdir -p $OUTDIR/logs
    echo "Directory $OUTDIR/logs/ does not exist - creating now..."
else
    echo "Directory $OUTDIR/logs/ already exists - moving on..."
fi

# If supertimeline OUTDIR does not exist, create it - else, continue 
if [ ! -d "$OUTDIR/image_export" ]; then
    echo "$OUTDIR/image_export/ does not exist - creating it now..."
    mkdir -p $OUTDIR/image_export
else
    echo "Directory $OUTDIR/image_export/ already exists - moving on..."
fi

# If $OUTDIR/foremost_slack is not empty, inform user and exit
if [ "$(ls -A $OUTDIR'/image_export')" ]; then
    echo "Directory $OUTDIR/image_export/ is not empty, clear it out before filling it up - exiting for now..."
    exit 1
else
    echo "Directory $OUTDIR/image_export/ is empty - let's fill it up!"
    image_export.py -f $EXPORTFILTER --vss_stores all -w $OUTDIR/image_export/ $DISKPATH
    #image_export.py --logfile $OUTDIR/logs/image_export.log -f $EXPORTFILTER --vss_stores all -w $OUTDIR/image_export/ $DISKPATH
fi

