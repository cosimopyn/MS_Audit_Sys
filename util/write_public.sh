#!/bin/bash

QDATA_DIR=`jq -r '.QDATA_DIR' ./config-util.json`
CON_DD=`jq -r '.CON_DD' ./config-util.json`
QUO_DD=`jq -r '.QUO_DD' ./config-util.json`

if [ ! -f "${QDATA_DIR}/.addresses.dat" ]; then
  touch ${QDATA_DIR}/.addresses.dat
  echo "File ${QDATA_DIR}/.addresses.dat does not exit. Created."
fi

DATE=`date -d today +"%Y-%m-%d"`
EXIST_DATE=`tail -n 1 ${QDATA_DIR}/.addresses.dat | cut -b 1-10`
ADDRESS=`tail -n 1 ${QDATA_DIR}/.addresses.dat | cut -d " " -f 2`

if [ "$EXIST_DATE"x == "$DATE"x ] && [ "$ADDRESS"x != ""x ]; then
  sed -i -e "s/var mess.*/var mess=\"$1\";/" public_exist_contract.js
  sed -i -e "s/var address.*/var address=\"$ADDRESS\";/" public_exist_contract.js
  OUT=`PRIVATE_CONFIG=${QDATA_DIR}/${CON_DD}/tm.ipc geth --exec "loadScript(\"public_exist_contract.js\")" attach ipc:${QDATA_DIR}/${QUO_DD}/geth.ipc`
  echo 'Record stored.'
  echo "Contract address is $ADDRESS."
  echo 'Please use ./read_data to get record'
else
  sed -i -e "s/var mess.*/var mess=\"$DATE\";/" public_new_contract.js
  OUT=`PRIVATE_CONFIG=${QDATA_DIR}/${CON_DD}/tm.ipc geth --exec "loadScript(\"public_new_contract.js\")" attach ipc:${QDATA_DIR}/${QUO_DD}/geth.ipc`
  TXN=`echo $OUT | cut -d " " -f 1`
  sed -i -e "s/var TXNHash.*/var TXNHash=\"$TXN\";/" get_contract_addr.js
  
  LOOP=true
  ITER=0
  while $LOOP; do
    sleep 1
    LOOP=false
    ITER=$((ITER+1))  
    echo 'Waiting to mine the block'
    OUT=`PRIVATE_CONFIG=${QDATA_DIR}/${CON_DD}/tm.ipc geth --exec "loadScript(\"get_contract_addr.js\")" attach ipc:${QDATA_DIR}/${QUO_DD}/geth.ipc`
    ADDRESS=`echo $OUT | cut -d " " -f 1`
    if [ "$ADDRESS"x != "err:"x ]; then
      LOOP=false
    fi
    if [ $ITER -eq 30 ]; then
      echo "Something goes wrong while mining. Please check logs."
      exit
    fi
  done

  sed -i -e "s/var mess.*/var mess=\"$1\";/" public_exist_contract.js
  sed -i -e "s/var address.*/var address=\"$ADDRESS\";/" public_exist_contract.js
  OUT=`PRIVATE_CONFIG=${QDATA_DIR}/${CON_DD}/tm.ipc geth --exec "loadScript(\"public_exist_contract.js\")" attach ipc:${QDATA_DIR}/${QUO_DD}/geth.ipc`
  
  echo 'New contract created and record stored.'
  echo "Contract address is $ADDRESS."
  echo 'Please use ./read_data to get record'
  echo "$DATE $ADDRESS" &>> ${QDATA_DIR}/.addresses.dat
fi
