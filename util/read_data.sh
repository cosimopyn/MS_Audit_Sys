#!/bin/bash

if [ $# -eq 0 ];
then
  echo "USAGE:./read_data command [options] [arguments...]"
  echo ""
  exit
fi

TYPE=`jq -r '.TYPE' config-util.json`
CON_DD=`jq -r '.CON_DD' config-util.json`
QUO_DD=`jq -r '.QUO_DD' config-util.json`
 
ATTACHPARAMETER="ipc:../$TYPE/qdata/$QUO_DD/geth.ipc"

if [ $1 == "-peer" ];
then
   # PRIVATE_CONFIG=../$TYPE/qdata/$CON_DD/tm.ipc geth attach $ATTACHPARAMETER << EOF | grep "Data: " | sed "s/Data: //"
  OUT=`PRIVATE_CONFIG=../$TYPE/qdata/$CON_DD/tm.ipc geth attach $ATTACHPARAMETER << EOF
  net.peerCount
  EOF`
  RES=`echo $OUT  | cut -d '>' -f 2`
  echo "Current peer number (except self) is:$RES"
elif [ $1 == "-block" ];
then
  PRIVATE_CONFIG=../$TYPE/qdata/$CON_DD/tm.ipc geth attach $ATTACHPARAMETER << EOF
  eth.blockNumber;
  EOF`
  RES=`echo $OUT  | cut -d '>' -f 2`
  echo "Current block number is:$RES"
elif [ $1 == "-data" ];
then
  if [ $# -lt 2 ];
  then
    
  else
    
  fi
else
echo "USAGE:./read_data command [options] [arguments...]"
fi
