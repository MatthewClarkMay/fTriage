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

if [ $# -ne 1 ]; then
    echo "$0: usage: pkiller.sh <PID LIST>"
    exit 1
else
    for pid in $(cat $1)
    do
        if ps -p $pid > /dev/null; then
            pid_command=$(ps -p $pid -o comm=)
            echo "KILLING - PID: $pid JOB: $pid_command"
            kill $pid
            sleep .01
        fi
    done
fi
