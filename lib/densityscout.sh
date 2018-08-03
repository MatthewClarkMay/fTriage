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

build_outdir "$OUTDIR/carving/densityscout"

# if $OUTDIR/carving/reduced_exes does not exist, inform user and exit - else, check density of contents
if [ ! -d "$OUTDIR/carving/reduced_exes" ] || [ -f $OUTDIR/carving/densityscout/densityscout_reduced_exes.txt ]; then
    echo "Directory $OUTDIR/carving/reduced_exes does not exist, or $OUTDIR/carving/densityscout_reduced_exes.txt already exists, must run /ftriage/lib/reduce_carved_files.sh first - exiting now..."
    exit 1
else
    echo "Directory $OUTDIR/carving/reduced_exes exists, checking density of contents..."
    densityscout -p $DENSITY -o $OUTDIR/carving/densityscout/densityscout_reduced_exes.txt $OUTDIR/carving/reduced_exes | tee "$OUTDIR"/carving/densityscout/densityscout_"$DENSITY"_reduced_exes_.txt
    #densityscout -pe -p $DENSITY -o $OUTDIR/carving/densityscout/densityscout_reduced_exes.txt $OUTDIR/carving/reduced_exes | tee "$OUTDIR"/carving/densityscout/densityscout_"$DENSITY"_reduced_exes_.txt
fi

# if $OUTDIR/image_export does not exist, inform user and exit - else, check density of contents
if [ ! -d "$OUTDIR/image_export" ] || [ -f $OUTDIR/carving/densityscout/densityscout_image_export.txt ]; then
    echo "Directory $OUTDIR/image_export/ does not exist, or $OUTDIR/carving/densityscout_image_export.txt already exists, must run /ftriage/lib/image_export.sh first - exiting now..."
    exit 1
else
    echo "Directory $OUTDIR/image_export/ exists, checking density of contents..."
    densityscout -r -p $DENSITY -o $OUTDIR/carving/densityscout/densityscout_image_export_c-windows.txt $OUTDIR/image_export/*indows | tee "$OUTDIR"/carving/densityscout/densityscout_"$DENSITY"_image_export_c-windows.txt
    #densityscout -r -pe -p $DENSITY -o $OUTDIR/carving/densityscout/densityscout_image_export_c-windows.txt $OUTDIR/image_export/*indows | tee "$OUTDIR"/carving/densityscout/densityscout_"$DENSITY"_image_export_c-windows.txt
    densityscout -r -p $DENSITY -o $OUTDIR/carving/densityscout/densityscout_image_export_c-users.txt $OUTDIR/image_export/*sers | tee "$OUTDIR"/carving/densityscout/densityscout_"$DENSITY"_image_export_c-users.txt
    #densityscout -r -pe -p $DENSITY -o $OUTDIR/carving/densityscout/densityscout_image_export_c-users.txt $OUTDIR/image_export/*sers | tee "$OUTDIR"/carving/densityscout/densityscout_"$DENSITY"_image_export_c-users.txt
fi

