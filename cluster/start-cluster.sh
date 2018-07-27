#!/bin/bash

HOST_IP=`jq -r '.HOST_IP' config-cluster.json`
PORT=`jq -r '.PORT' config-cluster.json`
RAFT_PORT=`jq -r '.RAFT_PORT' config-cluster.json`
RPC_PORT=`jq -r '.RPC_PORT' config-cluster.json`
CONSTE_PORT=`jq -r '.CONSTE_PORT' config-cluster.json`

echo "Host IP: $HOST_IP"
echo "Port: $PORT"
echo "RAFT Port: $RAFT_PORT"
echo "RPC Port: $RPC_PORT"
echo "Constellation Port: $CONSTE_PORT"

read -p "Is it right?(y/n): " CONFIRMED
if [ "$CONFIRMED"x != "y"x ]; then
    echo "Exiting, please edit \"./config-cluster.json\""
    exit
fi

set -u
set -e

NETWORK_ID=$(cat ../genesis.json | grep chainId | awk -F " " '{print $2}' | awk -F "," '{print $1}')
echo " Chain Id is $NETWORK_ID"
if [ $NETWORK_ID -eq 1 ]
then
	echo "  Quorum should not be run with a chainId of 1 (Ethereum mainnet)"
        echo "  please set the chainId in the genensis.json to another value "
	echo "  1337 is the recommend ChainId for Geth private clients."
fi

mkdir -p qdata/logs
echo "[*] Starting Constellation nodes"
./constellation-start.sh

echo "[*] Starting Ethereum nodes with ChainID and NetworkId of $NETWORK_ID"
set -v
ARGS="--nodiscover --verbosity 5 --networkid $NETWORK_ID --raft --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum --emitcheckpoints"
PRIVATE_CONFIG=qdata/c1/tm.ipc nohup geth --datadir qdata/dd1 $ARGS --raftport $((RAFT_PORT)) --rpcport $((RPC_PORT)) --port $((PORT)) --unlock 0 --password ../pw.data 2>>qdata/logs/1.log &
PRIVATE_CONFIG=qdata/c2/tm.ipc nohup geth --datadir qdata/dd2 $ARGS --raftport $((RAFT_PORT+1)) --rpcport $((RPC_PORT+1)) --port $((PORT+1)) --unlock 0 --password ../pw.data 2>>qdata/logs/2.log &
PRIVATE_CONFIG=qdata/c3/tm.ipc nohup geth --datadir qdata/dd3 $ARGS --raftport $((RAFT_PORT+2)) --rpcport $((RPC_PORT+2)) --port $((PORT+2)) --unlock 0 --password ../pw.data 2>>qdata/logs/3.log &
PRIVATE_CONFIG=qdata/c4/tm.ipc nohup geth --datadir qdata/dd4 $ARGS --raftport $((RAFT_PORT+3)) --rpcport $((RPC_PORT+3)) --port $((PORT+3)) --unlock 0 --password ../pw.data 2>>qdata/logs/4.log &
PRIVATE_CONFIG=qdata/c5/tm.ipc nohup geth --datadir qdata/dd5 $ARGS --raftport $((RAFT_PORT+4)) --rpcport $((RPC_PORT+4)) --port $((PORT+4)) --unlock 0 --password ../pw.data 2>>qdata/logs/5.log &
PRIVATE_CONFIG=qdata/c6/tm.ipc nohup geth --datadir qdata/dd6 $ARGS --raftport $((RAFT_PORT+5)) --rpcport $((RPC_PORT+5)) --port $((PORT+5)) --unlock 0 --password ../pw.data 2>>qdata/logs/6.log &
PRIVATE_CONFIG=qdata/c7/tm.ipc nohup geth --datadir qdata/dd7 $ARGS --raftport $((RAFT_PORT+6)) --rpcport $((RPC_PORT+6)) --port $((PORT+6)) --unlock 0 --password ../pw.data 2>>qdata/logs/7.log &
set +v

echo
echo "All nodes configured. See 'qdata/logs' for logs, and run e.g. 'geth attach qdata/dd1/geth.ipc' to attach to the first Geth node."
