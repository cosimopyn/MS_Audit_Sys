#!/bin/bash

. ./read_data.func

QDATA_DIR=`jq -r '.QDATA_DIR' ./config-util.json`
CON_DD=`jq -r '.CON_DD' ./config-util.json`
QUO_DD=`jq -r '.QUO_DD' ./config-util.json`
ATTACHPARAMETER="ipc:${QDATA_DIR}/${QUO_DD}/geth.ipc"
ABI='[{"constant":true,"inputs":[{"name":"idx","type":"uint256"}],"name":"get_record","outputs":[{"name":"retVal","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"get_num","outputs":[{"name":"num","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"record","type":"string"}],"name":"put","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"get_info","outputs":[{"name":"info","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"_info","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"_dataStore","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[{"name":"info","type":"string"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"}]'

# -peer command
if [ "$1"x == "-peer"x ]; then
  
  # --num option
  if [ "$2"x == "--num"x ]; then
    # PRIVATE_CONFIG=${QDATA_DIR}/${CON_DD}/tm.ipc geth attach $ATTACHPARAMETER <<EOF | grep "Data: " | sed "s/Data: //"
    OUT=`PRIVATE_CONFIG=${QDATA_DIR}/${CON_DD}/tm.ipc geth attach $ATTACHPARAMETER <<EOF
    net.peerCount;
    exit;
EOF`
  RES=`echo $OUT  | cut -d '>' -f 2`
  echo "Current peer number (except self) is:$RES"
  
  # --add option
  elif [ "$2"x == "--add"x ]; then
    OUT=`PRIVATE_CONFIG=${QDATA_DIR}/${CON_DD}/tm.ipc geth attach $ATTACHPARAMETER <<EOF
    raft.addPeer("$3");
    exit;
EOF`
  RES=`echo $OUT | cut -d '>' -f 2 | cut -d ' ' -f 2`
  if [ "$RES"x == "Error:"x ]; then
    echo 'Wrong Enode URL. Please check.'
  else
    echo "RADT ID of the new node is:$RES"
  fi
  
  # wrong option
  else
    show_help
  fi
  
# -block command
elif [ "$1"x == "-block"x ]; then
  OUT=`PRIVATE_CONFIG=${QDATA_DIR}/${CON_DD}/tm.ipc geth attach $ATTACHPARAMETER <<EOF
  eth.blockNumber;
  exit;
EOF`
  RES=`echo $OUT  | cut -d '>' -f 2`
  echo "Current block number is:$RES"
  
# -data command
elif [ "$1"x == "-data"x ]; then
  
  # --day option
  if [ "$2"x == "--day"x ]; then
    while read LINE;
    do
      # echo $LINE
      DATE=`echo $LINE | cut -d " " -f 1`
      if [ "$DATE"x == "$3"x ]; then
        ADDRESS=`echo $LINE | cut -d " " -f 2`
        get_data_via_address $ATTACHPARAMETER $QDATA_DIR $CON_DD $ABI $ADDRESS
        exit
      fi
    done  < ${QDATA_DIR}/.addresses.dat
    echo 'Wrong date format <YYYY-MM-DD>. Please check.'
    
  # --addr option
  elif [ "$2"x == "--addr"x ]; then 
    ADDRESS=$3
    get_data_via_address $ATTACHPARAMETER $QDATA_DIR $CON_DD $ABI $ADDRESS
    
  # wrong option
  else
    show_help
  fi
  
# -help command & wrong command
else
  show_help
fi