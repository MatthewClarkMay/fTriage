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

# https://tzworks.net/download_links.php - tzworks downloads page
# https://tzworks.net/prototype_page.php?proto_id=32 - August 2018 package build

wget https://www.tzworks.net/prototypes/builds/2018.07.28.lin64.zip
unzip *lin64.zip
chmod -R +x *lin64
#mkdir tzworks_package_2018-07-28_lin64 && unzip 2018.07.28.lin64.zip -d tzworks_package_2018-07-28_lin64

rm -rf *lin64.zip
