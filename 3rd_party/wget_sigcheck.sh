#!/bin/bash

# https://docs.microsoft.com/en-us/sysinternals/downloads/sigcheck

wget https://download.sysinternals.com/files/Sigcheck.zip &&
unzip Sigcheck.zip -d sigcheck &&
rm -rf Sigcheck.zip
