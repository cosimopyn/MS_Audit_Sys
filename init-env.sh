#!/bin/bash

# Generate keys
killall geth bootnode constellation-node
rm -rf qdata


# Local config
HOST_IP=172.16.1.4
PORT=21000
RPC_PORT=22000
RAFT_PORT=50401
CONSTE_POT=9001

# Cluster config
CLUSTER_IP=172.16.1.6
CLUS_CON_PORT=9001

# Password config


# Generate keys
mkdir -p qdata/dd/{keystore,geth}
mkdir -p qdata/con
# encrypted Constellation key pair
constellation-node --generatekeys=qdata/con/tm
# node key
bootnode -genkey qdata/dd/geth/nodekey
# private account key file
geth --keystore qdata/dd/keystore/ account new
# enode url
PUBKEY=`bootnode -nodekey qdata/dd/geth/nodekey -writeaddress`
ENODE_URL='enode://'"${PUBKEY}@${HOST_IP}:${PORT}"'?discport=0&raftport='"${RAFT_PORT}"
echo Your ENode URL is:
echo $ENODE_URL
echo

mkdir -p qdata/logs
touch qdata/logs/constellation.log
touch qdata/logs/quorum.log
