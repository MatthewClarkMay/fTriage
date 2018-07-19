#!/bin/bash 

if [ -f "./settings.conf" ]; then
    source ./settings.conf
else
    echo "./settings.conf missing - exiting..."
    exit 1
fi

#> $OUTDIR/batch-audit.txt

echo "Running DISK triage" | tee -a $OUTDIR/batch-audit.txt
echo "--------------" | tee -a $OUTDIR/batch-audit.txt
./vshadow.sh | tee -a $OUTDIR/batch-audit.txt
echo "--------------" | tee -a $OUTDIR/batch-audit.txt
./d_unallocated_filecarve.sh | tee -a $OUTDIR/batch-audit.txt
echo "--------------" | tee -a $OUTDIR/batch-audit.txt
./d_slack_filecarve.sh | tee -a $OUTDIR/batch-audit.txt
echo "--------------" | tee -a $OUTDIR/batch-audit.txt
./d_strings.sh | tee -a $OUTDIR/batch-audit.txt
echo "--------------" | tee -a $OUTDIR/batch-audit.txt
#./sorter.sh | tee -a $OUTDIR/batch-audit.txt

echo "--------------" | tee -a $OUTDIR/batch-audit.txt
echo "Running MEMORY triage" | tee -a $OUTDIR/batch-audit.txt
./m_filecarve.sh | tee -a $OUTDIR/batch-audit.txt
echo "--------------" | tee -a $OUTDIR/batch-audit.txt
./m_strings.sh | tee -a $OUTDIR/batch-audit.txt
echo "--------------" | tee -a $OUTDIR/batch-audit.txt
./filescan.sh | tee -a $OUTDIR/batch-audit.txt
echo "--------------" | tee -a $OUTDIR/batch-audit.txt
echo "Reducing Carved Files"
./reduce_carved_files.sh | tee -a $OUTDIR/batch-audit

echo "--------------" | tee -a $OUTDIR/batch-audit.txt
echo "Hashing suspect files" | tee -a $OUTDIR/batch-audit.txt
./hash_carved_files.sh | tee -a $OUTDIR/batch-audit.txt

echo "--------------" | tee -a $OUTDIR/batch-audit.txt
echo "Creating timeline" | tee -a $OUTDIR/batch-audit.txt
./timeline.sh | tee -a $OUTDIR/batch-audit.txt
echo "--------------" | tee -a $OUTDIR/batch-audit.txt

