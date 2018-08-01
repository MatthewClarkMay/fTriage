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

# If supertimeline OUTDIR does not exist, create it - else, continue 
if [ ! -d "$OUTDIR/supertimeline" ]; then
    echo "$OUTDIR/supertimeline/ does not exist - creating it now..."
    mkdir -p $OUTDIR/supertimeline
else
    echo "Directory $OUTDIR/supertimeline/ already exists - moving on..."
fi

if [[ $SUPERTIMELINE_START =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] && [[ $SUPERTIMELINE_END =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    echo "Date $SUPERTIMELINE_START and $SUPERTIMELINE_END are both in the correct format (YYYY-MM-DD) - moving on..."
else
    echo "Date $SUPERTIMELINE_START or $SUPERTIMELINE_END is invalid format (YYYY-MM-DD) - exiting..."
    exit 1
fi

# If $HOSTNAME.plaso file does not exist, create it - else, continue
if [ ! -f "$OUTDIR/supertimeline/$HOSTNAME.plaso" ]; then
    echo "Creating $OUTDIR/supertimeline/$HOSTNAME.plaso..."
    log2timeline.py --no-dependencies-check -f $L2TFILTER --vss_stores all $OUTDIR/supertimeline/$HOSTNAME.plaso $DISKPATH
else
    echo "File $OUTDIR/supertimeline/$HOSTNAME.plaso already exists - moving on..."
fi    

if [ ! -f "$OUTDIR/supertimeline/supertimeline.csv" ]; then
    echo "Creating $OUTDIR/supertimeline/supertimeline.csv..."
    psort.py -z $TIMEZONE -o L2tcsv $OUTDIR/supertimeline/$HOSTNAME.plaso "date > '$SUPERTIMELINE_START' AND date < '$SUPERTIMELINE_END'" -w $OUTDIR/supertimeline/supertimeline.csv
else   
    echo "File $OUTDIR/supertimeline/supertimeline.csv already exists - moving on..."
fi

if  [ -f "$OUTDIR/supertimeline/supertimeline.csv" ] && [ -f "$TIMELINE_REDUCE" ] && [ ! -f "$OUTDIR/supertimeline/supertimeline-filtered.csv" ]; then
    echo "Creating supertimeline-filtered.csv..."
    grep -a -v -i -f $TIMELINE_REDUCE $OUTDIR/supertimeline/supertimeline.csv > $OUTDIR/supertimeline/supertimeline-filtered.csv
else   
    echo "File $OUTDIR/supertimeline/supertimeline-filtered.csv already exists, or $TIMELINE_REDUCE does not exist - exiting..."
    exit 1
fi
