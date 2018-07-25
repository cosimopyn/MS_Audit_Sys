#!/bin/bash

# Local config
HOST_IP=172.16.1.4
PORT=21000
RPC_PORT=22000
RAFT_PORT=50401
CONSTE_PORT=9001
RAFT_ID= # add the Raft ID here

# Cluster config
CLUSTER_IP=172.16.1.6
CLUS_CON_PORT=9001

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
echo

# Start Quorum node
ARGS="--nodiscover --raft --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum --emitcheckpoints"
# --permissioned
PRIVATE_CONFIG=qdata/con/tm.ipc nohup geth --datadir qdata/dd $ARGS --raftjoinexisting $RAFT_ID --raftport $RAFT_PORT --rpcport $RPC_PORT --port $PORT --unlock 0 --password passwords.txt 2>>qdata/logs/quorum.log &
echo "Established Quorum node from host($HOST_IP:$PORT) to Network ($CLUSTER_IP)"
echo
