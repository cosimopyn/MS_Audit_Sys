#!/bin/bash

# Init env
echo '----------------------------------------------------------------------------'
echo "Local config:"
HOST_IP=`jq -r '.HOST_IP' ./config.json`
PORT=`jq -r '.PORT' ./config.json`
RAFT_PORT=`jq -r '.RAFT_PORT' ./config.json`
QDATA_DIR=`jq -r '.QDATA_DIR' ./config.json`
CON_DD=`jq -r '.CON_DD' ./config.json`
QUO_DD=`jq -r '.QUO_DD' ./config.json`

echo "HOST_IP=$HOST_IP"
echo "PORT=$PORT"
echo "RAFT_PORT=$RAFT_PORT"

echo '----------------------------------------------------------------------------'
echo "Start to initialize environment..."
killall geth bootnode constellation-node
rm -rf ${QDATA_DIR}

# Generate keys
echo "Start to generate keys..."
mkdir -p ${QDATA_DIR}/${QUO_DD}/keystore
mkdir -p ${QDATA_DIR}/${QUO_DD}/geth
mkdir -p ${QDATA_DIR}/${CON_DD}
# encrypted Constellation key pair
echo 'Now you need to enter your Constellation password  (you can use an empty one)'
constellation-node --generatekeys=${QDATA_DIR}/${CON_DD}/tm
# node key
bootnode -genkey ${QDATA_DIR}/${QUO_DD}/geth/nodekey
# private account key file
echo '----------------------------------------------------------------------------'
echo 'Next you need to enter your Etheruem password (you can use an empty one)'
echo '[*] Please remember to save it in \"pw.dat\" file later for login'
geth --keystore ${QDATA_DIR}/${QUO_DD}/keystore/ account new
# enode url
PUBKEY=`bootnode -nodekey ${QDATA_DIR}/${QUO_DD}/geth/nodekey -writeaddress`
ENODE_URL='enode://'"${PUBKEY}@${HOST_IP}:${PORT}"'?discport=0&raftport='"${RAFT_PORT}"
echo 'Your ENode URL is:'
echo "$ENODE_URL"

echo "[*] Before starting the node, run on server: ./run.sh -peer --add '$ENODE_URL'" 
# echo '----------------------------------------------------------------------------'
# echo 'Done'

mkdir -p ${QDATA_DIR}/logs
touch ${QDATA_DIR}/logs/constellation.log
touch ${QDATA_DIR}/logs/quorum.log
