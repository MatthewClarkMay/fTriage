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
    echo "ERROR - usage: $0 /path/to/ftriage.conf"
    exit 1
else
    source $1
fi

rm -rf $OUTDIR/carving/$HOSTNAME.blkls.slack 2>/dev/null
rm -rf $OUTDIR/carving/$HOSTNAME.blkls.unallocated 2>/dev/null

rm -rf $OUTDIR/timeline/fls.bodyfile 2>/dev/null
rm -rf $OUTDIR/timeline/vol-timeliner.bodyfile 2>/dev/null
rm -rf $OUTDIR/timeline/fls-vol-timeliner.bodyfile 2>/dev/null

