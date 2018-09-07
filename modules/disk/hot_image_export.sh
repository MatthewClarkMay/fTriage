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

check_dir_exists "$MOUNTPATH"

# If $OUTDIR/image_export does not exist, create it - else, continue 
build_outdir "$OUTDIR/image_export"

# If $OUTDIR/image_export is not empty, inform user and exit
if_not_empty_exit_else_continue "$OUTDIR/image_export"

image_export.py -f $EXPORTFILTER --partitions all -w $OUTDIR/image_export/ $MOUNTPATH
#image_export.py -f $EXPORTFILTER --vss_stores all --partitions all -w $OUTDIR/image_export/ $MOUNTPATH

