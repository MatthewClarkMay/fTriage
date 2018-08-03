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
build_outdir "$OUTDIR/carving/tsk_recover"

# If tsk OUTDIR is not empty, inform user and exit
if_not_empty_exit_else_continue "$OUTDIR/carving/tsk_recover"

echo "Carving unallocated files using tsk_recover..."

tsk_recover $DISKPATH $OUTDIR/carving/tsk_recover

