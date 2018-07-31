#!/bin/bash

# https://tzworks.net/prototype_page.php?proto_id=15
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
