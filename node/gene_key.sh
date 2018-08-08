#!/bin/bash

# Init env
echo '----------------------------------------------------------------------------'
echo "Local config:"
HOST_IP=`jq -r '.HOST_IP' ./config.json`
PORT=`jq -r '.PORT' ./config.json`
RAFT_PORT=`jq -r '.RAFT_PORT' ./config.json`
QDATA_DIR=`jq -r '.QDATA_DIR' ./config.json`

echo "HOST_IP=$HOST_IP"
echo "PORT=$PORT"
echo "RAFT_PORT=$RAFT_PORT"

echo '----------------------------------------------------------------------------'
echo "Start to initialize environment..."
killall geth bootnode constellation-node
rm -rf ${QDATA_DIR}

# Generate keys
echo "Start to generate keys..."
mkdir -p ${QDATA_DIR}/dd/keystore
mkdir -p ${QDATA_DIR}/dd/geth
mkdir -p ${QDATA_DIR}/con
# encrypted Constellation key pair
echo 'Now you need to enter your Constellation password  (you can use an empty one)'
constellation-node --generatekeys=${QDATA_DIR}/con/tm
# node key
bootnode -genkey ${QDATA_DIR}/dd/geth/nodekey
# private account key file
echo '----------------------------------------------------------------------------'
echo 'Next you need to enter your Etheruem password (you can use an empty one)'
echo '[*] Please remember to save it in \"pw.dat\" file later for login'
geth --keystore ${QDATA_DIR}/dd/keystore/ account new
# enode url
PUBKEY=`bootnode -nodekey ${QDATA_DIR}/dd/geth/nodekey -writeaddress`
ENODE_URL='enode://'"${PUBKEY}@${HOST_IP}:${PORT}"'?discport=0&raftport='"${RAFT_PORT}"
echo 'Your ENode URL is:'
echo "$ENODE_URL"
ACCOUNT=0x`geth --keystore ${QDATA_DIR}/dd/keystore/ account list | cut -d " " -f 3 | cut -b 2-41` 
CON_PUB_KEY=`cat ${QDATA_DIR}/con/tm.pub`
echo '[*] Please login in any node of the blockchain network'
echo "[*] Run ./run.sh -peer --add '$ENODE_URL' $ACCOUNT $CON_PUB_KEY"
echo '[*] Then get the command line to start node' 

#echo '[*] Please use ipc to login in any node of the blockchain network instead of http '
#echo '[*] Run > raft.addPeer("'$ENODE_URL'");'
#echo '[*] And then get RAFT ID and edit "config.json" file' 
echo '----------------------------------------------------------------------------'
echo 'Done'

mkdir -p ${QDATA_DIR}/logs
touch ${QDATA_DIR}/logs/constellation.log
touch ${QDATA_DIR}/logs/quorum.log
