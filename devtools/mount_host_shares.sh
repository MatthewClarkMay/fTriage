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
