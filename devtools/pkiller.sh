#!/bin/bash

if [ $# -ne 1 ]; then
    echo "$0: usage: pkiller.sh <PID>"
    exit 1
else
    for pid in $(cat $1)
    do
        echo "Killing PID $pid"
        kill $pid
    done
fi
