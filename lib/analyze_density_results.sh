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

if [ ! -d "$OUTDIR/carving/densityscout" ] || [ ! "$(ls -A $OUTDIR/carving/densityscout)" ]; then
    echo "Directory $OUTDIR/carving/densityscout is empty, or does not exist - run ftriage/lib/densityscout.sh"
    exit 1
fi

build_outdir "$OUTDIR/carving/high_density_exes"
if_not_empty_exit_else_continue "$OUTDIR/carving/high_density_exes"

echo "Analyzing densityscout results..."

while read line; do
    if  echo "$line" | grep -q -P '\(\d\.\d{5}\)\s\|\s'; then
        # Replace leading and trailing whitespace 
        binpath=$(echo "$line" | cut -d"|" -f2 | sed 's/^[ \t]*//;s/[ \t]*$//') # full path
        binbase=$(basename $binpath) # base name - win7-32-nromanoff-c-drive.E01-47933-128-1.exe
        diskbase=$(basename $DISKPATH)

        # Find sorter exes
        if echo "$binpath" | grep -q $diskbase; then
            inode=$(echo "${binbase//$diskbase/}" | awk -F "-" '{ print $2"-"$3"-"$4 }' | cut -d"." -f1)
            original=$(grep -v "Saved to:" "$OUTDIR"/carving/sorter/exec.txt | grep -B3 $inode | egrep 'C:' | sed 's@.*/@@')
            if [ ${#original} -gt 15 ]; then
                original=$(echo $original | cut -c -15)
            fi
            echo $binbase
            echo $inode
            echo $original
            echo ""
            #cp "$binpath" "$OUTDIR"/carving/high_density_exes/"$binbase"-"$original"
        fi

    #cp "$binpath" "$OUTDIR/carving/high_density_exes"
    fi
done < "$OUTDIR"/carving/densityscout/densityscout_"$DENSITY"_reduced_exes.txt

# Possible output formats for files carved
# foremost - 00282684.exe
# sorter - win7-32-nromanoff-c-drive.E01-55118-128-1.exe
# dlldump - module.2840.7fb36a60.75680000.dll
# dumpfiles - file.208.0x85e91b48.cmd.exe.img

# ORIGINAL FILEPATH
# foremost - NO
# sorter - YES - grep -v "Saved to:" $OUTDIR/carving/sorter/exec.txt | grep -B3 $inode | egrep 'C:'
# dlldump - PARTIAL - grep $module $OUTDIR/carving/volatility/dlldump_audit.txt | awk '{ print $4 }'
# dumpfiles - FULL, but hard to distinguish - grep $pid $OUTDIR/carving/volatility/dumpfiles_*_audit.txt

# Batch - pescan.exe against every file in directory with pipe (csv)
# dir SiftShare\high_density_exes /b /s | win64.demo\bin\pescan.exe -pipe -csv -base10 -anomalies > pescan.csv
# Batch - pescan.exe against every file in directory without pipe (txt)
# for %F in (SiftShare\high_density_exes\*) do win64.demo\bin\pescan.exe %F >> pescan.txt
