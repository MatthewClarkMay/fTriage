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

if [ ! -d "$OUTDIR/carving/reduced_exes" ] || [ ! "$(ls -A $OUTDIR/carving/reduced_exes)" ]; then
    echo "Directory $OUTDIR/carving/reduced_exes is empty, or does not exist - run ftriage/modules/analysis/reduce_carved_exes.sh"
    exit 1
fi

check_dir_exists "$OUTDIR/carving/aggregate_exes"

echo "Renaming aggregate_exes..."
echo ""

if [ -f "$OUTDIR"/carving/densityscout/densityscout_"$DENSITY"_reduced_exes.txt ]; then
    diskbase=$(basename "$DISKPATH")
    while read line; do
        # Begin foremost parsing and renaming
        if echo "$line" | grep -q -P '\(\d\.\d{5}\)\s\|\s'; then
            # Replace leading and trailing whitespace 
            binpath=$(echo "$line" | cut -d"|" -f2 | sed 's/^[ \t]*//;s/[ \t]*$//') # full path
            binbase=$(basename "$binpath") # base name - win7-32-nromanoff-c-drive.E01-47933-128-1.exe

            # Begin foremost parsing and renaming
            # NOTE: Not sure yet how to map these to original filenames, so for now will just cp high density files as is
            if echo "$binbase" | grep -q -P '^\d{8}\.(exe|dll)'; then
                # cp foremost files to high_density_exes outdir
                cp "$binpath" "$OUTDIR"/carving/high_density_exes/foremost-"$binbase"

                echo "$binpath"
                echo "$binbase"
                echo ""
            fi
            # End foremost parsing and renaming

            # Begin Sorter parsing and renaming
            if echo "$binbase" | grep -q "$diskbase"; then # if file carved by sorter
                inode=$(echo "${binbase//$diskbase/}" | awk -F "-" '{ print $2"-"$3"-"$4 }' | cut -d"." -f1) # for this inode
                # parse these audit result lists for original file name
                sorter_audit_results=( 
                                    "exec.txt"
                                    "adobepdf.txt"
                                    "documents.txt"
                                     ) 
                for txt in "${sorter_audit_results[@]}" # loop through the lists
                do # etc...
                    if [ -f "$OUTDIR/carving/sorter/$txt" ] && grep -q "$inode" "$OUTDIR/carving/sorter/$txt"; then
                        # translate white space into dash or underscore?
                        original=$(grep -v "Saved to:" "$OUTDIR"/carving/sorter/$txt | grep -B3 "$inode" | egrep 'C:' | sed 's@.*/@@')
                    fi
                done
            
                # truncate real filenames to 20 chars to prevent super long filenames
                if [ "${#original}" -gt 20 ]; then
                    original=$(echo $original | cut -c -20) # quotation marks around $original breaks parsing
                fi

                # cp and rename sorter files to high_density_exes outdir
                cp "$binpath" "$OUTDIR"/carving/high_density_exes/sorter-"$binbase"-"$original"

                echo "$binbase"
                echo "$inode"
                echo "$original"
                echo ""
            fi
            # End sorter parsing and renaming

            # Begin dlldump parsing and renaming
            if echo "$binbase" | grep -q -P 'module\.\d+\.[a-zA-Z0-9]+\.[a-zA-Z0-9]+\.dll'; then
                # parse dlldump_audit.txt for original file name
                original=$(grep "$binbase" "$OUTDIR"/carving/volatility/dlldump_audit.txt | awk '{ print $4 }')
                # truncate real filenames to 20 chars to prevent super long filenames
                if [ "${#original}" -gt 20 ]; then
                    original=$(echo $original | cut -c -20) # quotation marks around $original breaks parsing
                fi

                # cp and rename dlldump files to high_density_exes outdir
                cp "$binpath" "$OUTDIR"/carving/high_density_exes/dlldump-"$binbase"-"$original"

                echo "$binbase"
                echo "$original"
                echo ""
                #IDEA - parse and print dll memory address
            fi
            # End dlldump parsing and renaming

            # Begin dumpfiles parsing and renaming
            if echo "$binbase" | grep -q -P 'file\.\d+\.[a-zA-Z0-9]+\.[a-zA-Z0-9]+\.(dll|exe)\.'; then
               original=$(echo "$binbase" | awk -F "." '{ print $4"."$5 }')
               
              # cp and rename dumpfiles files to high_density_exes outdir
               cp "$binpath" "$OUTDIR"/carving/high_density_exes/dumpfiles-"$binbase"

               echo "$binbase"
               echo "$original"
               echo ""
             fi
            # End dumpfiles parsing and renaming
        fi
    done < "$OUTDIR"/carving/densityscout/densityscout_"$DENSITY"_reduced_exes.txt
fi

# Possible output formats for files carved
# foremost - 00282684.exe
# sorter - win7-32-nromanoff-c-drive.E01-55118-128-1.exe
# dlldump - module.2840.7fb36a60.75680000.dll
# dumpfiles - file.208.0x85e91b48.cmd.exe.img

# ORIGINAL FILEPATH
# foremost - NO
# sorter - YES - grep -v "Saved to:" $OUTDIR/carving/sorter/exec.txt | grep -B3 $inode | egrep 'C:'
# dlldump - PARTIAL (filename without full path) - grep $module $OUTDIR/carving/volatility/dlldump_audit.txt | awk '{ print $4 }'
# dumpfiles - FULL, but hard to distinguish - grep $pid $OUTDIR/carving/volatility/dumpfiles_*_audit.txt

# Batch - pescan.exe against every file in directory with pipe (csv)
# dir SiftShare\high_density_exes /b /s | win64.demo\bin\pescan.exe -pipe -csv -base10 -anomalies > pescan.csv
# Batch - pescan.exe against every file in directory without pipe (txt)
# for %F in (SiftShare\high_density_exes\*) do win64.demo\bin\pescan.exe %F >> pescan.txt
