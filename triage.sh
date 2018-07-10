#!/bin/bash

source ./var.conf

##########################
######### Prep ###########
##########################
echo ""
echo "------------------------------"
echo "----- Cleaning Old Files -----"
echo "------------------------------"

rm -rf $OUTDIR/*


##########################
##### hiberfil.sys #######
##########################
echo ""
echo "------------------------------"
echo "---- imageinfo hiberfile  ----"
echo "------------------------------"
echo ""
mkdir $OUTDIR/hiberfil-analysis

echo 'Feature commented out - performance hit...'
#vol.py -f /mnt/windows_mount/hiberfil.sys imagecopy --profile=$PROFILE -O $OUTDIR/hiberfil-analysis/hiberfil.raw

##########################
####### Processes ########
##########################
mkdir $OUTDIR/process-checks

echo ""
echo "------------------------------"
echo "---------- pslist ------------"
echo "------------------------------"
echo ""

vol.py -f $MEMPATH --profile=$PROFILE pslist > $OUTDIR/process-checks/pslist.txt

echo ""
echo "------------------------------"
echo "---------- psscan ------------"
echo "------------------------------"
echo ""

vol.py -f $MEMPATH --profile=$PROFILE psscan > $OUTDIR/process-checks/psscan.txt

echo ""
echo "------------------------------"
echo "---------- pstree ------------"
echo "------------------------------"
echo ""

vol.py -f $MEMPATH --profile=$PROFILE pstree > $OUTDIR/process-checks/pstree.txt

echo ""
echo "------------------------------"
echo "--------- pstree.v -----------"
echo "------------------------------"
echo ""

vol.py -f $MEMPATH --profile=$PROFILE pstree -v > $OUTDIR/process-checks/pstree-verbose.txt

echo ""
echo "------------------------------"
echo "-------- malprocfind ---------"
echo "------------------------------"
echo ""

vol.py -f $MEMPATH --profile=$PROFILE malprocfind > $OUTDIR/process-checks/malprocfind.txt

echo ""
echo "------------------------------"
echo "------- malprocfind.x --------"
echo "------------------------------"
echo ""

vol.py -f $MEMPATH --profile=$PROFILE malprocfind -x > $OUTDIR/process-checks/malprocfind-verbose.txt


##########################
##### Code Injection #####
##########################
#mkdir -p $OUTDIR/process-checks/malfind/malfind-binary-dump-dir
mkdir $OUTDIR/code-injection

echo ""
echo "------------------------------"
echo "---------- malfind -----------"
echo "------------------------------"
echo ""

vol.py -f $MEMPATH --profile=$PROFILE malfind > $OUTDIR/code-injection/malfind-raw.txt 
#vol.py -f $MEMPATH --profile=$PROFILE malfind -D $OUTDIR/code-injection/malfind-binary-dump-dir > $OUTDIR/process-checks/malfind/malfind-raw.txt 

# This could introduce false negatives in cases where MZ is absent
cat $OUTDIR/code-injection/malfind-raw.txt | egrep -B 4 '^0x.+\sMZ' > $OUTDIR/code-injection/malfind-MZ.txt

# Creates unique list of suspect code injected processes based on malfind + grep MZ
cat $OUTDIR/code-injection/malfind-MZ.txt | grep 'Process' | cut -d " " -f2,4 | sort -cu > $OUTDIR/code-injection/malfind-MZ-unique-pid.txt 


##########################
### Rootkit Detection  ###
##########################
mkdir -p $OUTDIR/rootkit-checks/drivers

echo ""
echo "------------------------------"
echo "----------- ssdt  ------------"
echo "------------------------------"
echo ""

vol.py -f $MEMPATH --profile=$PROFILE ssdt > $OUTDIR/rootkit-checks/ssdt.txt
vol.py -f $MEMPATH --profile=$PROFILE ssdt | egrep -v '(ntoskrnl|win32k)' > $OUTDIR/rootkit-checks/ssdt-filtered.txt

echo ""
echo "------------------------------"
echo "---------- psxview  ----------"
echo "------------------------------"
echo ""

vol.py -f $MEMPATH --profile=$PROFILE psxview > $OUTDIR/rootkit-checks/psxview.txt

echo ""
echo "------------------------------"
echo "--- Gathering Driver Data ----"
echo "------------------------------"
echo ""

### Drivers / Modules
vol.py -f $MEMPATH --profile=$PROFILE modscan > $OUTDIR/rootkit-checks/drivers/modscan.txt
vol.py -f $MEMPATH --profile=$PROFILE modules > $OUTDIR/rootkit-checks/drivers/modules.txt
vol.py -f $MEMPATH --profile=$PROFILE devicetree > $OUTDIR/rootkit-checks/drivers/devicetree.txt


echo ""
echo "------------------------------"
echo "--------- apihooks  ----------"
echo "------------------------------"
echo ""

echo 'Feature commented out - performance hit...'
#vol.py -f $MEMPATH --profile=$PROFILE apihooks > $OUTDIR/rootkit-checks/psxview.txt
#vol.py -f $MEMPATH --profile=$PROFILE apihooks -Q > $OUTDIR/rootkit-checks/psxview-critical.txt

echo ""
echo "------------------------------"
echo "------------ idt  ------------"
echo "------------------------------"
echo ""

vol.py -f $MEMPATH --profile=$PROFILE psxview > $OUTDIR/rootkit-checks/idt.txt

echo ""
echo "------------------------------"
echo "-------- driverirp  ----------"
echo "------------------------------"
echo ""

vol.py -f $MEMPATH --profile=$PROFILE driverirp > $OUTDIR/rootkit-checks/driverirp.txt


##########################
### Extracting Objects ###
##########################
mkdir $OUTDIR/extracted

echo ""
echo "------------------------------"
echo "--------- cmdscan  -----------"
echo "------------------------------"
echo ""

vol.py -f $MEMPATH --profile=$PROFILE cmdscan > $OUTDIR/extracted/cmdscan.txt

echo ""
echo "------------------------------"
echo "--------- consoles  ----------"
echo "------------------------------"
echo ""

vol.py -f $MEMPATH --profile=$PROFILE consoles > $OUTDIR/extracted/consoles.txt

echo ""
echo "------------------------------"
echo "--------- filescan  ----------"
echo "------------------------------"
echo ""

vol.py -f $MEMPATH --profile=$PROFILE filescan > $OUTDIR/extracted/filescan.txt


##########################
### Registry Forensics  ##
##########################
mkdir $OUTDIR/registry-artifacts

echo ""
echo "------------------------------"
echo "---------- hivelist  ---------"
echo "------------------------------"
echo ""

vol.py -f $MEMPATH --profile=$PROFILE hivelist > $OUTDIR/registry-artifacts/hivelist.txt

echo ""
echo "------------------------------"
echo "---------- printkey  ---------"
echo "------------------------------"
echo ""

vol.py -f $MEMPATH --profile=$PROFILE printkey > $OUTDIR/registry-artifacts/printkey.txt

echo ""
echo "------------------------------"
echo "---------- svcscan  ----------"
echo "------------------------------"
echo ""

vol.py -f $MEMPATH --profile=$PROFILE svcscan > $OUTDIR/registry-artifacts/svcscan.txt

echo ""
echo "------------------------------"
echo "---------- autoruns ----------"
echo "------------------------------"
echo ""

echo Feature Under Maintenance
#vol.py -f $MEMPATH --profile=$PROFILE autoruns -v > $OUTDIR/registry-artifacts/autoruns-verbose.txt

### Dumping hashes
echo ""
echo "------------------------------"
echo "--------- hashdump  ----------"
echo "------------------------------"
echo ""

vol.py -f $MEMPATH --profile=$PROFILE hashdump > $OUTDIR/registry-artifacts/hashdump.txt

### Dumping LSA secrets
echo ""
echo "------------------------------"
echo "--------- lsadump  ----------"
echo "------------------------------"
echo ""

vol.py -f $MEMPATH --profile=$PROFILE lsadump > $OUTDIR/registry-artifacts/lsadump.txt
### Dumping passwords
echo ""
echo "------------------------------"
echo "--------- mimikatz  ----------"
echo "------------------------------"
echo ""

vol.py -f $MEMPATH --profile=$PROFILE mimikatz > $OUTDIR/registry-artifacts/mimikatz.txt

echo ""
echo "------------------------------"
echo "-------- userassist  ---------"
echo "------------------------------"
echo ""

vol.py -f $MEMPATH --profile=$PROFILE userassist > $OUTDIR/registry-artifacts/userassist.txt


##########################
####### shimcache  #######
##########################
echo ""
echo "------------------------------"
echo "--------- shimcache  ---------"
echo "------------------------------"
echo ""

vol.py -f $MEMPATH --profile=$PROFILE shimcache > $OUTDIR/registry-artifacts/shimcache-vol.txt
vol.py -f $MEMPATH --profile=$PROFILE shimcachemem -c --output=csv > $OUTDIR/registry-artifacts/shimcachemem-vol.csv

ShimCacheParser.py -i /mnt/windows_mount/WINDOWS/system32/config/system --bom -o $OUTDIR/registry-artifacts/ShimCacheParser.csv

# Win7+
# rfc.pl /mnt/windows_mount/Windows/AppCompat/Programs/RecentFileCache.bcf


##########################
### Prefetch Carving  ####
##########################
mkdir $OUTDIR/prefetch-carving

echo ""
echo "------------------------------"
echo "----------- blkls  -----------"
echo "------------------------------"
echo ""

echo 'Feature commented out - performance hit...'
#blkls $DISKPATH > $OUTDIR/prefetch-carving/$HOSTNAME.blkls

#foremost -q -b 4096 -o $OUTDIR/prefetch-carving/foremost -c /usr/local/etc/foremost.conf $OUTDIR/prefetch-carving/$HOSTNAME.blkls

#for i in $OUTDIR/prefetch-carving/foremost/pf/*.pf; do pf -csv $i; done | grep .pf, | cut -d, -f1,2,3,4,5 > $OUTDIR/prefetch-carving/recovered-pf-analysis.csv

echo ""
echo "------------------------------"
echo "------ prefetchparser  -------"
echo "------------------------------"
echo ""

echo 'Feature commented out - performance hit...'
#vol.py -f $MEMPATH --profile=$PROFILE prefetchparser > $OUTDIR/prefetch-carving/prefetchparser.txt


