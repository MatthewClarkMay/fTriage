#!/bin/bash

if [ $# -ne 1 ]; then
    echo "$0: usage: plaso_specs.sh <plaso.dump>"
    exit 1
else
    pinfo.py $1 | grep -i specification -A 5
fi
