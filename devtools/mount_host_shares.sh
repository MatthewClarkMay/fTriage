#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

dir="/root/host_shares"

if [ ! -d "$dir" ]; then
    echo "Directory $dir does not exist - creating now and mounting host dirs..."
    mkdir "$dir"
    /usr/bin/vmhgfs-fuse .host:/ "$dir" -o subtype=vmhgfs-fuse,allow_other
else
    echo "Directory $dir exists - mounting host dirs..."
    /usr/bin/vmhgfs-fuse .host:/ "$dir" -o subtype=vmhgfs-fuse,allow_other
fi
