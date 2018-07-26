#!/bin/bash

# Init env
echo '----------------------------------------------------------------------------'
echo "Start to initialize environment..."
killall geth bootnode constellation-node
rm -rf qdata
echo "Local config:"
HOST_IP=`jq -r '.HOST_IP' config.json`
PORT=`jq -r '.PORT' config.json`
RAFT_PORT=`jq -r '.RAFT_PORT' config.json`
echo "HOST_IP=$HOST_IP"
echo "PORT=$PORT"
echo "RAFT_PORT=$RAFT_PORT"
echo '----------------------------------------------------------------------------'

# Generate keys
echo "Start to generate keys..."
mkdir -p qdata/dd/keystore
mkdir -p qdata/dd/geth
mkdir -p qdata/con
# encrypted Constellation key pair
echo 'Now you need to enter your Constellation password  (you can use an empty one)'
constellation-node --generatekeys=qdata/con/tm
# node key
bootnode -genkey qdata/dd/geth/nodekey
# private account key file
echo '----------------------------------------------------------------------------'
echo 'Next you need to enter your Etheruem password (you can use an empty one)'
echo '[*] Please save it in \"pw.data\" file later for login'
geth --keystore qdata/dd/keystore/ account new
# enode url
PUBKEY=`bootnode -nodekey qdata/dd/geth/nodekey -writeaddress`
ENODE_URL='enode://'"${PUBKEY}@${HOST_IP}:${PORT}"'?discport=0&raftport='"${RAFT_PORT}"
echo "Your ENode URL is: $ENODE_URL"
echo '[*] Please run > raft.addPeer("'$ENODE_URL'") in any node of the blockchain network to get RAFT_ID' 
echo 'And edit RAFT_ID in \"confige.json\" file' 
echo '----------------------------------------------------------------------------'
echo 'Done'

mkdir -p qdata/logs
touch qdata/logs/constellation.log
touch qdata/logs/quorum.log
