#!/bin/bash

function show_help()
{
  echo "USAGE: "
  echo "./read_data command [option] [argument]"
  echo "            -block                      Get current block number"
  echo "            -peer                       Get current peer number in the private network (excepet self)"
  echo "            -help                       Show help"
  echo "            -data                       Get data in the blockchain"
  echo "                    --day    <YYYY-MM-DD>      Date"
  echo "                    --addr   <Address Hash>    Address hash"

}

QDATA_DIR=`jq -r '.QDATA_DIR' ./config-util.json`
CON_DD=`jq -r '.CON_DD' ./config-util.json`
QUO_DD=`jq -r '.QUO_DD' ./config-util.json`
ATTACHPARAMETER="ipc:${QDATA_DIR}/${QUO_DD}/geth.ipc"
ABI='[{"constant":true,"inputs":[{"name":"idx","type":"uint256"}],"name":"get_record","outputs":[{"name":"retVal","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"get_num","outputs":[{"name":"num","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"record","type":"string"}],"name":"put","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"get_info","outputs":[{"name":"info","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"_info","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"_dataStore","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[{"name":"info","type":"string"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"}]'
    
if [ "$1"x == "-peer"x ]; then
   # PRIVATE_CONFIG=${QDATA_DIR}/${CON_DD}/tm.ipc geth attach $ATTACHPARAMETER <<EOF | grep "Data: " | sed "s/Data: //"
  OUT=`PRIVATE_CONFIG=${QDATA_DIR}/${CON_DD}/tm.ipc geth attach $ATTACHPARAMETER <<EOF
  net.peerCount;
  exit;
EOF`
  RES=`echo $OUT  | cut -d '>' -f 2`
  echo "Current peer number (except self) is:$RES"
elif [ "$1"x == "-block"x ]; then
  OUT=`PRIVATE_CONFIG=${QDATA_DIR}/${CON_DD}/tm.ipc geth attach $ATTACHPARAMETER <<EOF
  eth.blockNumber;
  exit;
EOF`
  RES=`echo $OUT  | cut -d '>' -f 2`
  echo "Current block number is:$RES"
elif [ "$1"x == "-data"x ]; then

  if [ "$2"x == "--day"x ]; then
    echo "day"
  elif [ "$2"x == "--addr"x ]; then
  
    OUT=`PRIVATE_CONFIG=${QDATA_DIR}/${CON_DD}/tm.ipc geth attach $ATTACHPARAMETER <<EOF
    var simpleContract = web3.eth.contract(${ABI});
    var simple = simpleContract.at("$3");
    console.log(simple.get_info());
    exit;
EOF`
    RES=`echo $OUT  | cut -d '>' -f 4 | cut -d ' ' -f 2`
    
    if [ "$RES"x == "Error:"x ]; then
      echo 'Contract address is wrong. Please check'
    else
      echo "Contract info is $RES"
      OUT=`PRIVATE_CONFIG=${QDATA_DIR}/${CON_DD}/tm.ipc geth attach $ATTACHPARAMETER <<EOF
      var simpleContract = web3.eth.contract(${ABI});
      var simple = simpleContract.at("$3");
      console.log(simple.get_num());
      exit;
EOF`
      CONTRACT_NUM=`echo $OUT  | cut -d '>' -f 4 | cut -d ' ' -f 2`
      echo "It contains $CONTRACT_NUM records:"
      CONTRACT_NUM=10
      for ((i=0;i<CONTRACT_NUM;i++))
      do
        OUT=`PRIVATE_CONFIG=${QDATA_DIR}/${CON_DD}/tm.ipc geth attach $ATTACHPARAMETER <<EOF
        var simpleContract = web3.eth.contract(${ABI});
        var simple = simpleContract.at("$3");
        console.log(simple.get_record($i));
        exit;
EOF`
        RECORD=`echo $OUT  | cut -d '>' -f 4 | cut -d ' ' -f 2`
        echo $RECORD
      done
    fi
    
    # echo "Current block number is:$RES"

  else
    show_help
  fi
else
  show_help
fi
