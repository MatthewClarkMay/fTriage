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

# If $OUTDIR/carving/volatility/process_checks does not exist, create it - else, continue 
build_outdir "$OUTDIR/carving/volatility/process_checks"

# if $OUTDIR/carving/volatility/process_checks/malprocfind.txt already exists, move on - else, create and begin automated memory analysis
if [ -f "$OUTDIR/carving/volatility/process_checks/malprocfind.txt" ]; then
    echo "File $OUTDIR/carving/volatility/process_checks/malprocfind.txt already exists - moving on..."
else
    echo "Finding malicious processes based on discrepancies from observed, normal behavior and properties..."
    echo ""

    printf "PPID - Proper parent process\nName - Name permutations check\nPath - Execution from correct folder location\nPriority - Process priority check (most system processes have a higher priority)\nCmdline - Process has expected arguments (useful for svchost.exe)\nUser - Process SID is as expected\nSess - Process is running in the correct Windows Session (most system processes run in Session 0)\nTime - Was the process executed within (n) number of seconds after boot (false positive prone)\nCMD - Did cmd.exe spawn the process?\nPHollow - Is the image binary unmapped?\nSPath - Is the process running from a suspicious path like Temp, Recycle Bin, etc.\n\n" | tee $OUTDIR/carving/volatility/process_checks/malprocfind.txt

    vol.py --profile=$PROFILE -f $MEMPATH malprocfind | tee -a $OUTDIR/carving/volatility/process_checks/malprocfind.txt
fi

# if $OUTDIR/carving/volatility/process_checks/malprocfind_with_exited.txt already exists, move on - else, create and begin automated memory analysis
if [ -f "$OUTDIR/carving/volatility/process_checks/malprocfind_with_exited.txt" ]; then
    echo "File $OUTDIR/carving/volatility/process_checks/malprocfind_with_exited.txt already exists - moving on..."
else
    echo "Finding malicious processes based on discrepancies from observed, normal behavior and properties..."
    echo "EXITED PROCESS TOO..."
    echo ""

    printf "PPID - Proper parent process\nName - Name permutations check\nPath - Execution from correct folder location\nPriority - Process priority check (most system processes have a higher priority)\nCmdline - Process has expected arguments (useful for svchost.exe)\nUser - Process SID is as expected\nSess - Process is running in the correct Windows Session (most system processes run in Session 0)\nTime - Was the process executed within (n) number of seconds after boot (false positive prone)\nCMD - Did cmd.exe spawn the process?\nPHollow - Is the image binary unmapped?\nSPath - Is the process running from a suspicious path like Temp, Recycle Bin, etc.\n\n" | tee $OUTDIR/carving/volatility/process_checks/malprocfind_with_exited.txt

    vol.py --profile=$PROFILE -f $MEMPATH malprocfind -x | tee -a $OUTDIR/carving/volatility/process_checks/malprocfind_with_exited.txt
fi
