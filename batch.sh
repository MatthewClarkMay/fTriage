#!/bin/bash 

if [ -f "./settings.conf" ]; then
    source ./settings.conf
else
    echo "./settings.conf missing - exiting..."
    exit 1
fi

echo "Running DISK triage"
./d_unallocated_filecarve.sh
./d_slack_filecarve.sh
./d_strings.sh
#./sorter.sh

echo "Running MEMORY triage"
./m_filecarve.sh
./m_strings.sh
./filescan.sh
