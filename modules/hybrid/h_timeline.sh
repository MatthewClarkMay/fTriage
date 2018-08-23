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
build_outdir "$OUTDIR/h_timeline"

# If fls bodyfile does not exist, create it - else, continue
if [ ! -f "$OUTDIR/h_timeline/fls.bodyfile" ] && [ -f "$DISKPATH" ]; then
    echo "Creating fls bodyfile..."
    fls -r -m C: $DISKPATH > $OUTDIR/h_timeline/fls.bodyfile
else
    echo "File $OUTDIR/h_timeline/fls.bodyfile already exists, or DISKPATH variable does not exist - moving on..."
fi    

# If volatility timeliner bodyfile does not exist, create it - else, continue
if [ ! -f "$OUTDIR/h_timeline/vol_timeliner.bodyfile" ] && [ -f "$MEMPATH" ]; then
    echo "Creating volatility timeliner bodyfile..."
    vol.py -f $MEMPATH --profile=$PROFILE timeliner --output=body --output-file=$OUTDIR/h_timeline/vol_timeliner.bodyfile
else
    echo "File $OUTDIR/h_timeline/vol_timeliner.bodyfile already exists, or MEMPATH variable does not exist - moving on..."
fi    

# Combine fls.bodyfile and vol_timeliner.bodyfile
if [ -f "$OUTDIR/h_timeline/fls.bodyfile" ] && [ -f "$OUTDIR/h_timeline/vol_timeliner.bodyfile" ]; then
    echo "Files fls.bodyfile and vol_timeliner.bodyfile both detected - combining now..."
    cp $OUTDIR/h_timeline/fls.bodyfile $OUTDIR/h_timeline/fls_vol_timeliner.bodyfile
    cat $OUTDIR/h_timeline/vol_timeliner.bodyfile >> $OUTDIR/h_timeline/fls_vol_timeliner.bodyfile
    BODYFILE="$OUTDIR/h_timeline/fls_vol_timeliner.bodyfile"
elif [ -f "$OUTDIR/h_timeline/fls.bodyfile" ] && [ ! -f "$OUTDIR/h_timeline/vol_timeliner.bodyfile" ]; then
    echo "File fls.bodyfile detected, but vol_timeliner.bodyfile was not - moving on..."
    BODYFILE="$OUTDIR/h_timeline/fls.bodyfile"
elif [ ! -f "$OUTDIR/h_timeline/fls.bodyfile" ] && [ -f "$OUTDIR/h_timeline/vol_timeliner.bodyfile" ]; then
    echo "File vol_timeliner.bodyfile detected, but fls.bodyfile was not - moving on..."
    BODYFILE="$OUTDIR/h_timeline/vol_timeliner.bodyfile"
elif [ ! -f "$OUTDIR/h_timeline/fls.bodyfile" ] && [ ! -f "$OUTDIR/h_timeline/vol_timeliner.bodyfile" ]; then
    echo "Neither body files detected - exiting..."
    exit 1
fi

if [[ $TIMELINE_START =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] && [[ $TIMELINE_END =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    echo "Date $TIMELINE_START and $TIMELINE_END are both in the correct format (YYYY-MM-DD) - moving on..."
else
    echo "Date $TIMELINE_START or $TIMELINE_END is invalid format (YYYY-MM-DD) - exiting..."
    exit 1
fi

# If unfiltered mactime timeline file does not exist, create it - else, continue
if [ ! -f "$OUTDIR/h_timeline/h_timeline.csv" ]; then
    echo "Creating h_timeline.csv..."
    mactime -z UTC -y -d -b $BODYFILE $TIMELINE_START..$TIMELINE_END > $OUTDIR/h_timeline/h_timeline.csv
else
    echo "File h_timeline.csv already exists - exiting now..."
    #echo "File h_timeline.csv already exists - replacing now..."
    #mactime -z UTC -y -d -b $BODYFILE $TIMELINE_START..$TIMELINE_END > $OUTDIR/h_timeline/h_timeline.csv
fi    

if [ -f "$OUTDIR/h_timeline/h_timeline.csv" ] && [ -f $TIMELINE_REDUCE ] && [ ! -f $OUTDIR/h_timeline/h_timeline_filtered.csv ]; then
    echo "Creating h_timeline_filtered.csv..."
    grep -v -i -f $TIMELINE_REDUCE $OUTDIR/h_timeline/h_timeline.csv > $OUTDIR/h_timeline/h_timeline_filtered.csv
else   
    echo "File h_timeline.csv does not exist, or $TIMELINE_REDUCE does not exist - exiting..."
    exit 1
fi
