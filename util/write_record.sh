#!/bin/bash

QDATA_DIR=`jq -r '.QDATA_DIR' ./config-util.json`
CON_DD=`jq -r '.CON_DD' ./config-util.json`
QUO_DD=`jq -r '.QUO_DD' ./config-util.json`

if [ ! -f "${QDATA_DIR}/.addresses.dat" ]; then
  touch ${QDATA_DIR}/.addresses.dat
  echo "File ${QDATA_DIR}/.addresses.dat does not exit. Contact Server."
fi

CUSTOMER=`date -d today +"%Y-%m-%d"`
EXIST_DATE=`tail -n 1 ${QDATA_DIR}/.addresses.dat | cut -b 1-10`

if [ "$EXIST_DATE"x == "$DATE"x ]; then
  ADDRESS=`tail -n 1 ${QDATA_DIR}/.addresses.dat | cut -d " " -f 2`
  sed -i -e "s/var mess.*/var mess=\"$1\";/" public_exist_contract.js
  sed -i -e "s/var address.*/var address=\"$ADDRESS\";/" public_exist_contract.js
  OUT=`PRIVATE_CONFIG=${QDATA_DIR}/${CON_DD}/tm.ipc geth --exec "loadScript(\"public_exist_contract.js\")" attach ipc:${QDATA_DIR}/${QUO_DD}/geth.ipc`
  echo 'Record stored.'
  echo "Contract address is $ADDRESS"
  echo 'To get record, please use ./read_data '
else
  new_contract_get_addr() $INFO $QDATA_DIR $CON_DD= $QUO_DD
fi
