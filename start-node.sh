#!/bin/bash

echo "Confirm local config ..."
RAFT_ID=`jq -r '.RAFT_ID' config.json`
HOST_IP=`jq -r '.HOST_IP' config.json`
PORT=`jq -r '.PORT' config.json`
RAFT_PORT=`jq -r '.RAFT_PORT' config.json`
RPC_PORT=`jq -r '.RPC_PORT' config.json`
CONSTE_PORT=`jq -r '.CONSTE_PORT' config.json`
echo "RAFT ID: $RAFT_ID (it should be generated on a node in the cluster)"
echo "Host IP: $HOST_IP"
echo "Port: $PORT"
echo "RAFT Port: $RAFT_PORT"
echo "RPC Port: $RPC_PORT"
echo "Constellation Port: $CONSTE_PORT"
echo "Confirm cluster config ..."
CLUSTER_IP=`jq -r '.CLUSTER_IP' config.json`
CLUS_CON_PORT=`jq -r '.CLUS_CON_PORT' config.json`
echo "Cluste IP: $CLUSTER_IP"
echo "Cluster Constellation Port: $CLUS_CON_PORT"

read -p "Is it right?(y/n): " CONFIRMED
if [ "$CONFIRMED"x != "y"x ]; then
    echo "Exiting, please edit \"config.json\""
    exit
fi
echo "Confirmed"
echo '----------------------------------------------------------------------------'
echo "Start to run node..."
# Start Constellation node
rm -f qdata/con/tm.ipc
CMD="constellation-node --url=https://$HOST_IP:$CONSTE_PORT/ --port=$CONSTE_PORT --workdir=qdata/con --socket=tm.ipc --publickeys=tm.pub --privatekeys=tm.key --othernodes=https://$CLUSTER_IP:$CLUS_CON_PORT/"
echo "$CMD >> qdata/logs/constellation.log 2>&1 &"
$CMD >> "qdata/logs/constellation.log" 2>&1 &

DOWN=true
while $DOWN; do
    sleep 0.1
    DOWN=false
    if [ ! -S "qdata/con/tm.ipc" ]; then
        DOWN=true
    fi
done
echo "Established Constellation node from host($HOST_IP:$CONSTE_PORT) to Network ($CLUSTER_IP:$CLUS_CON_PORT)"
echo '----------------------------------------------------------------------------'


NETWORK_ID=$(cat genesis.json | grep chainId | awk -F " " '{print $2}' | awk -F "," '{print $1}')
if [ $NETWORK_ID -eq 1 ]
then
    echo "  Quorum should not be run with a chainId of 1 (Ethereum mainnet)"
    echo "  please set the chainId in the genensis.json to another value "
    echo "  1337 is the recommend ChainId for Geth private clients."
fi

# Start Quorum node
ARGS="--nodiscover -verbosity 5 --networkid $NETWORK_ID --raft --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum --emitcheckpoints"
# --permissioned
PRIVATE_CONFIG=qdata/con/tm.ipc nohup geth --datadir qdata/dd $ARGS --raftjoinexisting $RAFT_ID --raftport $RAFT_PORT --rpcport $RPC_PORT --port $PORT --unlock 0 --password pw.data 2>>qdata/logs/quorum.log &
echo "Established Quorum node from host($HOST_IP:$PORT) to Network ($CLUSTER_IP)"
echo '----------------------------------------------------------------------------'
echo "Done"
echo "Please run $ geth attach http://$HOST_IP:$PORT to attach this node"

