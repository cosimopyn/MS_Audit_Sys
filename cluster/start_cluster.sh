#!/bin/bash

HOST_IP=`jq -r '.HOST_IP' config-cluster.json`
PORT=`jq -r '.PORT' config-cluster.json`
RAFT_PORT=`jq -r '.RAFT_PORT' config-cluster.json`
RPC_PORT=`jq -r '.RPC_PORT' config-cluster.json`
CONSTE_PORT=`jq -r '.CONSTE_PORT' config-cluster.json`
QDATA_DIR=`jq -r '.QDATA_DIR' ./config-cluster.json`
HOST_IP_BASE=`jq -r '.HOST_IP_BASE' ./config-cluster.json`
HOST_IP_OFFSET=`jq -r '.HOST_IP_OFFSET' ./config-cluster.json`

echo "Host IP: $HOST_IP"
echo "Port: $PORT"
echo "RAFT Port: $RAFT_PORT"
echo "RPC Port: $RPC_PORT"
echo "Constellation Port: $CONSTE_PORT"
echo "Host IP Base: $HOST_IP_BASE"
echo "Host IP Offset: $HOST_IP_OFFSET"

read -p "Is it right?(y/n): " CONFIRMED
if [ "$CONFIRMED"x != "y"x ]; then
    echo "Exiting, please edit \"./config-cluster.json\""
    exit
fi

set -u
set -e

NETWORK_ID=$(cat ../genesis.json | grep chainId | awk -F " " '{print $2}' | awk -F "," '{print $1}')
echo "Chain Id is $NETWORK_ID"
if [ $NETWORK_ID -eq 1 ]; then
  echo "Quorum should not be run with a chainId of 1 (Ethereum mainnet)"
  echo "Please set the chainId in the genensis.json to another value "
  echo "1337 is the recommend ChainId for Geth private clients."
  exit
fi

mkdir -p ${QDATA_DIR}/logs
echo "[*] Starting Constellation nodes"
./constellation_start.sh

echo "[*] Starting Ethereum nodes with ChainID and NetworkId of $NETWORK_ID"
set -v
ARGS="--nodiscover --verbosity 5 --networkid $NETWORK_ID --raft --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum --emitcheckpoints"
PRIVATE_CONFIG=${QDATA_DIR}/c1/tm.ipc nohup geth --datadir ${QDATA_DIR}/dd1 $ARGS --raftport $((RAFT_PORT)) --rpcport $((RPC_PORT)) --port $((PORT)) --unlock 0 --password ../pw.dat 2>>${QDATA_DIR}/logs/quorum1.log &
PRIVATE_CONFIG=${QDATA_DIR}/c2/tm.ipc nohup geth --datadir ${QDATA_DIR}/dd2 $ARGS --raftport $((RAFT_PORT+1)) --rpcport $((RPC_PORT+1)) --port $((PORT+1)) --unlock 0 --password ../pw.dat 2>>${QDATA_DIR}/logs/quorum2.log &
PRIVATE_CONFIG=${QDATA_DIR}/c3/tm.ipc nohup geth --datadir ${QDATA_DIR}/dd3 $ARGS --raftport $((RAFT_PORT+2)) --rpcport $((RPC_PORT+2)) --port $((PORT+2)) --unlock 0 --password ../pw.dat 2>>${QDATA_DIR}/logs/quorum3.log &
PRIVATE_CONFIG=${QDATA_DIR}/c4/tm.ipc nohup geth --datadir ${QDATA_DIR}/dd4 $ARGS --raftport $((RAFT_PORT+3)) --rpcport $((RPC_PORT+3)) --port $((PORT+3)) --unlock 0 --password ../pw.dat 2>>${QDATA_DIR}/logs/quorum4.log &
PRIVATE_CONFIG=${QDATA_DIR}/c5/tm.ipc nohup geth --datadir ${QDATA_DIR}/dd5 $ARGS --raftport $((RAFT_PORT+4)) --rpcport $((RPC_PORT+4)) --port $((PORT+4)) --unlock 0 --password ../pw.dat 2>>${QDATA_DIR}/logs/quorum5.log &
PRIVATE_CONFIG=${QDATA_DIR}/c6/tm.ipc nohup geth --datadir ${QDATA_DIR}/dd6 $ARGS --raftport $((RAFT_PORT+5)) --rpcport $((RPC_PORT+5)) --port $((PORT+5)) --unlock 0 --password ../pw.dat 2>>${QDATA_DIR}/logs/quorum6.log &
PRIVATE_CONFIG=${QDATA_DIR}/c7/tm.ipc nohup geth --datadir ${QDATA_DIR}/dd7 $ARGS --raftport $((RAFT_PORT+6)) --rpcport $((RPC_PORT+6)) --port $((PORT+6)) --unlock 0 --password ../pw.dat 2>>${QDATA_DIR}/logs/quorum7.log &
set +v

echo 'All nodes configured. For logs, see '"${QDATA_DIR}/logs" 
echo 'To attach to the Geth node, pelase run '"geth attach ${QDATA_DIR}/dd1/geth.ipc" 
