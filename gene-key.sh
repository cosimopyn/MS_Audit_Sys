#!/bin/bash

# Init env
echo "Start to initialize environment..."
killall geth bootnode constellation-node
rm -rf qdata
source ./config
echo '----------------------------------------------------------------------------'

# Generate keys
echo "Start to generate keys..."
mkdir -p qdata/dd/keystore
mkdir -p qdata/dd/geth
mkdir -p qdata/con
# encrypted Constellation key pair
echo '----------------------------------------------------------------------------'
echo 'Now you need to enter your Constellation password'
constellation-node --generatekeys=qdata/con/tm
# node key
bootnode -genkey qdata/dd/geth/nodekey
# private account key file
echo '----------------------------------------------------------------------------'
echo 'Next you need to enter your Etheruem password. Please save it in pw.data file later for login'
geth --keystore qdata/dd/keystore/ account new
# enode url
PUBKEY=`bootnode -nodekey qdata/dd/geth/nodekey -writeaddress`
ENODE_URL='enode://'"${PUBKEY}@${HOST_IP}:${PORT}"'?discport=0&raftport='"${RAFT_PORT}"
echo Your ENode URL is: $ENODE_URL
echo 'Please run > raft.addPeer("'$ENODE_URL'") in any node of the blockchain network to get RAFT_ID' 
echo '----------------------------------------------------------------------------'
echo 'Done'

mkdir -p qdata/logs
touch qdata/logs/constellation.log
touch qdata/logs/quorum.log
