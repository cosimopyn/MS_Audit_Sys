#!/bin/bash

DATE=`date -d today +"%Y-%m-%d"`
EXIST_DATE=`tail -n 1 .addresses.dat | cut -b 1-10`

if [ "$EXIST_DATE"x == "$DATE"x ];
then
  ADDRESS=`tail -n 1 a|cut -b 12-`
  sed -i -e "s/var mess.*/var mess=\"$1\";/" public_exist_contract.js
  sed -i -e "s/var address.*/var address=\"$ADDRESS\";/" public_exist_contract.js
  #PRIVATE_CONFIG=../node/qdata/con/tm.ipc geth --exec "loadScript(\"public_exist_contract.js\")" attach ipc:../node/qdata/dd/geth.ipc
else
  sed -i -e "s/var mess.*/var mess=\"$1\";/" public_new_contract.js
  OUT=`PRIVATE_CONFIG=../cluster/qdata/c2/tm.ipc geth --exec "loadScript(\"public_new_contract.js\")" attach ipc:../cluster/qdata/dd2/geth.ipc`
  TXN=`echo $OUT | cut -d " " -f 1`
  sed -i -e "s/var TXNHash.*/var TXNHash=\"$TXN\";/" get_contract_addr.js
  
  OUT=`PRIVATE_CONFIG=../cluster/qdata/c2/tm.ipc geth --exec "loadScript(\"get_contract_addr.js\")" attach ipc:../cluster/qdata/dd2/geth.ipc`
  ADDRESS=`echo $OUT | cut -d " " -f 1`
  
#  DOWN=true
#  ITER=0
#  while $DOWN; do
#    sleep 0.1
#    DOWN=false
#    ITER=$((ITER+1))
#    ADDRESS=`PRIVATE_CONFIG=../cluster/qdata/c2/tm.ipc geth --exec "loadScript(\"get_contract_addr.js\")" attach ipc:../cluster/qdata/dd2/geth.ipc`
#    if [ ! -S "qdata/con/tm.ipc" ] || [ $ITER -eq 100 ]; then
#      DOWN=true
#    fi
#  done
  
  echo "Contract stored. Address is $ADDRESS. Please use to get record"
  echo "$DATE $ADDRESS" &>> .addresses.dat
fi
