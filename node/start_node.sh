#!/bin/bash

if [ $# -ne 1 ]; then
  echo 'Lack of arguments. Please check output of Server.'
  exit
fi

echo "Confirm local config ..."
RAFT_ID=$1
HOST_IP=`jq -r '.HOST_IP' ./config.json`
PORT=`jq -r '.PORT' ./config.json`
RAFT_PORT=`jq -r '.RAFT_PORT' ./config.json`
RPC_PORT=`jq -r '.RPC_PORT' ./config.json`
CONSTE_PORT=`jq -r '.CONSTE_PORT' ./config.json`
QDATA_DIR=`jq -r '.QDATA_DIR' ./config.json`
echo "RAFT ID: $RAFT_ID"
echo "Host IP: $HOST_IP"
echo "Port: $PORT"
echo "RAFT Port: $RAFT_PORT"
echo "RPC Port: $RPC_PORT"
echo "QDATA Dir: $QDATA_DIR"
echo "Constellation Port: $CONSTE_PORT"
echo "Confirm cluster config ..."
CLUSTER_IP=`jq -r '.CLUSTER_IP' ./config.json`
CLUS_CON_PORT=`jq -r '.CLUS_CON_PORT' ./config.json`
echo "Cluste IP: $CLUSTER_IP"
echo "Cluster Constellation Port: $CLUS_CON_PORT"

touch ${QDATA_DIR}/.addresses.dat

read -p "Is it right?(y/n): " CONFIRMED
if [ "$CONFIRMED"x != "y"x ]; then
    echo "Exiting, please edit \"config.json\""
    exit
fi
echo "Confirmed"
echo '----------------------------------------------------------------------------'

echo "Start to run node..."
# Init Quorum node
geth --datadir ${QDATA_DIR}/dd init ../genesis.json

# Start Constellation node
rm -f ${QDATA_DIR}/con/tm.ipc
CMD="constellation-node --url=https://$HOST_IP:$CONSTE_PORT/ --port=$CONSTE_PORT --workdir=${QDATA_DIR}/con --socket=tm.ipc --publickeys=tm.pub --privatekeys=tm.key --othernodes=https://$CLUSTER_IP:$CLUS_CON_PORT/"
echo "$CMD >> ${QDATA_DIR}/logs/constellation.log 2>&1 &"
$CMD >> "${QDATA_DIR}/logs/constellation.log" 2>&1 &

DOWN=true
while $DOWN; do
    sleep 0.1
    DOWN=false
    if [ ! -S "${QDATA_DIR}/con/tm.ipc" ]; then
        DOWN=true
    fi
done
echo "Established Constellation node from host($HOST_IP:$CONSTE_PORT) to Network ($CLUSTER_IP:$CLUS_CON_PORT)"
echo '----------------------------------------------------------------------------'


NETWORK_ID=$(cat ../genesis.json | grep chainId | awk -F " " '{print $2}' | awk -F "," '{print $1}')
if [ $NETWORK_ID -eq 1 ]
then
    echo "  Quorum should not be run with a chainId of 1 (Ethereum mainnet)"
    echo "  please set the chainId in the genensis.json to another value "
    echo "  1337 is the recommend ChainId for Geth private clients."
fi

# Start Quorum node
ARGS="--nodiscover -verbosity 5 --networkid $NETWORK_ID --raft --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum --emitcheckpoints"
# --permissioned
PRIVATE_CONFIG=${QDATA_DIR}/con/tm.ipc nohup geth --datadir ${QDATA_DIR}/dd $ARGS --raftjoinexisting $RAFT_ID --raftport $RAFT_PORT --rpcport $RPC_PORT --port $PORT --unlock 0 --password ../pw.dat 2>>${QDATA_DIR}/logs/quorum.log &
echo "Established Quorum node from host($HOST_IP:$PORT) to Network ($CLUSTER_IP)"
echo '----------------------------------------------------------------------------'
echo "Done"
echo 'To attach to the Geth node, pelase run '"geth attach ${QDATA_DIR}/dd/geth.ipc" 

touch ${QDATA_DIR}/.addresses.dat
echo "customer$((RAFT_ID-7)) $2" &>> ${QDATA_DIR}/.addresses.dat

ACCOUNT=0x`geth --keystore ${QDATA_DIR}/dd/keystore/ account list | cut -d " " -f 3 | cut -b 2-41` 
CON_PUB_KEY=`cat ${QDATA_DIR}/con/tm.pub`
echo "[*] To create contract, run on server: ./run.sh -create customer$((RAFT_ID-7)) $ACCOUNT '$CON_PUB_KEY'"
