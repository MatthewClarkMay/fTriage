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

# If $OUTDIR/carving/volatility/rootkits does not exist, create it - else, continue 
build_outdir "$OUTDIR/carving/volatility/rootkits"

# if $OUTDIR/carving/volatility/rootkits/apihooks_raw.txt already exists, move on - else, create and begin automated memory analysis
if [ -f "$OUTDIR/carving/volatility/rootkits/apihooks_raw.txt" ]; then
    echo "File $OUTDIR/carving/volatility/rootkits/apihooks_raw.txt already exists - moving on..."
else
    echo "Running Volatility apihooks plugin with no parameters..."
    echo ""
    vol.py --profile=$PROFILE -f $MEMPATH apihooks > $OUTDIR/carving/volatility/rootkits/apihooks_raw.txt
fi

# if $OUTDIR/carving/volatility/rootkits/apihooks_critical.txt already exists, move on - else, create and begin automated memory analysis
if [ -f "$OUTDIR/carving/volatility/rootkits/apihooks_raw.txt" ]; then
    echo "File $OUTDIR/carving/volatility/rootkits/apihooks_raw.txt already exists - moving on..."
else
    echo "Running Volatility apihooks plugin with -Q parameter (scan only critical processes and dlls)..."
    echo ""
    vol.py --profile=$PROFILE -f $MEMPATH apihooks -Q > $OUTDIR/carving/volatility/rootkits/apihooks_critical.txt
fi
