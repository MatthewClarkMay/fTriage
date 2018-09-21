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

if [ -f "./rds_modernm/NSRLFile.txt" ]; then
    echo "Running hfind against ./rds_modernm/NSRLFile.txt..."
    hfind -i nsrl-md5 ./rds_modernm/NSRLFile.txt
else
    echo "./rds_modernm/NSRLFile.txt does not exist - exiting..."
    exit 1
fi
