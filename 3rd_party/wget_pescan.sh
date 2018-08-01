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

# https://tzworks.net/prototype_page.php?proto_id=15 - pescan webpage
# https://tzworks.net/prototypes/pescan/pescan.users.guide.pdf

#wget https://www.tzworks.net/prototypes/pescan/pescan32.v.0.43.win.zip &&
#unzip pescan32.v.0.43.win.zip -d pescan32-win

#wget https://www.tzworks.net/prototypes/pescan/pescan64.v.0.43.win.zip &&
#unzip pescan64.v.0.43.win.zip -d pescan64-win

#wget https://www.tzworks.net/prototypes/pescan/pescan32.v.0.43.lin.tar.gz &&
#mkdir pescan32-lin && tar xzvf pescan32.v.0.43.lin.tar.gz -C pescan32-lin

wget https://www.tzworks.net/prototypes/pescan/pescan64.v.0.43.lin.tar.gz &&
mkdir pescan64-lin && tar xzvf pescan64.v.0.43.lin.tar.gz -C pescan64-lin

#rm -rf pescan*win.zip
rm -rf pescan*lin.tar.gz
