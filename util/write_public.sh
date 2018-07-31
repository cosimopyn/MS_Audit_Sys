#!/bin/bash

TYPE=`jq -r '.TYPE' config-util.json`
CON_DD=`jq -r '.CON_DD' config-util.json`
QUO_DD=`jq -r '.QUO_DD' config-util.json`

DATE=`date -d today +"%Y-%m-%d"`
EXIST_DATE=`tail -n 1 .addresses.dat | cut -b 1-10`

if [ "$EXIST_DATE"x == "$DATE"x ];
then
  ADDRESS=`tail -n 1 .addresses.dat | cut -d " " -f 2`
  sed -i -e "s/var mess.*/var mess=\"$1\";/" public_exist_contract.js
  sed -i -e "s/var address.*/var address=\"$ADDRESS\";/" public_exist_contract.js
  OUT=`PRIVATE_CONFIG=../$TYPE/qdata/$CON_DD/tm.ipc geth --exec "loadScript(\"public_exist_contract.js\")" attach ipc:../$TYPE/qdata/$QUO_DD/geth.ipc`
  echo "Record stored. Address is $ADDRESS. Please use to get record"
else
  sed -i -e "s/var mess.*/var mess=\"$DATE\";/" public_new_contract.js
  OUT=`PRIVATE_CONFIG=../$TYPE/qdata/$CON_DD/tm.ipc geth --exec "loadScript(\"public_new_contract.js\")" attach ipc:../$TYPE/qdata/$QUO_DD/geth.ipc`
  TXN=`echo $OUT | cut -d " " -f 1`
  sed -i -e "s/var TXNHash.*/var TXNHash=\"$TXN\";/" get_contract_addr.js
  
#  DOWN=true
#  ITER=0
#  while $DOWN; do
    sleep 1
#    DOWN=false
#    ITER=$((ITER+1))
#    ADDRESS=`PRIVATE_CONFIG=../cluster/qdata/c2/tm.ipc geth --exec "loadScript(\"get_contract_addr.js\")" attach ipc:../cluster/qdata/dd2/geth.ipc`
#    if [ ! -S "qdata/con/tm.ipc" ] || [ $ITER -eq 100 ]; then
#      DOWN=true
#    fi
#  done

  OUT=`PRIVATE_CONFIG=../$TYPE/qdata/$CON_DD/tm.ipc geth --exec "loadScript(\"get_contract_addr.js\")" attach ipc:../$TYPE/qdata/$QUO_DD/geth.ipc`
  ADDRESS=`echo $OUT | cut -d " " -f 1`
  
  sed -i -e "s/var mess.*/var mess=\"$1\";/" public_exist_contract.js
  sed -i -e "s/var address.*/var address=\"$ADDRESS\";/" public_exist_contract.js
  OUT=`PRIVATE_CONFIG=../$TYPE/qdata/$CON_DD/tm.ipc geth --exec "loadScript(\"public_exist_contract.js\")" attach ipc:../$TYPE/qdata/$QUO_DD/geth.ipc`
  
  echo "New contract created and record stored. Address is $ADDRESS. Please use to get record"
  echo "$DATE $ADDRESS" &>> .addresses.dat
fi
