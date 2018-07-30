#!/bin/bash

sed -i "1d" 
sed -i "var mess=\"$1\";"

cur_date=`date -d today +"%Y-%m-%d"`

# PRIVATE_CONFIG=qdata/con/tm.ipc geth --exec "loadScript(\"\")" attach ipc:qdata/dd/geth.ipc
