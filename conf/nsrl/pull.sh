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

# Reference:
# https://www.nist.gov/itl/ssd/software-quality-group/nsrl-download/current-rds-hash-sets

#wget https://s3.amazonaws.com/rds.nsrl.nist.gov/RDS/current/README.txt
#wget https://s3.amazonaws.com/rds.nsrl.nist.gov/RDS/current/RDS_HashCounts.txt
#wget https://s3.amazonaws.com/rds.nsrl.nist.gov/RDS/current/version.txt

# Modern RDS (microcomputer applications from 2000 to present)
#wget https://s3.amazonaws.com/rds.nsrl.nist.gov/RDS/current/RDS_modern.iso

# Modern RDS (minimal)
wget https://s3.amazonaws.com/rds.nsrl.nist.gov/RDS/current/rds_modernm.zip

# Modern RDS (unique)
#wget https://s3.amazonaws.com/rds.nsrl.nist.gov/RDS/current/rds_modernu.zip

# Android RDS
#wget https://s3.amazonaws.com/rds.nsrl.nist.gov/RDS/current/RDS_android.iso

# IOS RDS
#wget https://s3.amazonaws.com/rds.nsrl.nist.gov/RDS/current/RDS_ios.iso

# Legacy RDS (microcomputer applications from 1999 and earlier)
#wget https://s3.amazonaws.com/rds.nsrl.nist.gov/RDS/current/RDS_legacy.iso
