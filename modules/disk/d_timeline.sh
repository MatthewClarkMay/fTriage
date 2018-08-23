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

# If timeline OUTDIR does not exist, create it - else, continue 
build_outdir "$OUTDIR/d_timeline"

# If fls bodyfile does not exist, create it - else, continue
if [ ! -f "$OUTDIR/d_timeline/fls.bodyfile" ] && [ -f "$DISKPATH" ]; then
    echo "Creating fls bodyfile..."
    fls -r -m C: $DISKPATH > $OUTDIR/d_timeline/fls.bodyfile
else
    echo "File $OUTDIR/d_timeline/fls.bodyfile already exists, or DISKPATH variable does not exist - moving on..."
fi    

if [ -f "$OUTDIR/d_timeline/fls.bodyfile" ]; then
    echo "File fls.bodyfile detected - moving on..."
    BODYFILE="$OUTDIR/d_timeline/fls.bodyfile"
else
    echo "fls.bodyfile does not exist - exiting..."
    exit 1
fi

if [[ $TIMELINE_START =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] && [[ $TIMELINE_END =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    echo "Date $TIMELINE_START and $TIMELINE_END are both in the correct format (YYYY-MM-DD) - moving on..."
else
    echo "Date $TIMELINE_START or $TIMELINE_END is invalid format (YYYY-MM-DD) - exiting..."
    exit 1
fi

# If unfiltered mactime timeline file does not exist, create it - else, continue
if [ ! -f "$OUTDIR/d_timeline/d_timeline.csv" ]; then
    echo "Creating d_timeline.csv..."
    mactime -z UTC -y -d -b $BODYFILE $TIMELINE_START..$TIMELINE_END > $OUTDIR/d_timeline/d_timeline.csv
else
    echo "File d_timeline.csv already exists - exiting now..."
    #echo "File d_timeline.csv already exists - replacing now..."
    #mactime -z UTC -y -d -b $BODYFILE $TIMELINE_START..$TIMELINE_END > $OUTDIR/d_timeline/d_timeline.csv
fi    

if [ -f "$OUTDIR/d_timeline/d_timeline.csv" ] && [ -f $TIMELINE_REDUCE ] && [ ! -f $OUTDIR/d_timeline/d_timeline_filtered.csv ]; then
    echo "Creating d_timeline_filtered.csv..."
    grep -v -i -f $TIMELINE_REDUCE $OUTDIR/d_timeline/d_timeline.csv > $OUTDIR/d_timeline/d_timeline_filtered.csv
else   
    echo "File d_timeline.csv does not exist, or $TIMELINE_REDUCE does not exist - exiting..."
    exit 1
fi
