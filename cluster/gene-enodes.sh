#!/bin/bash

echo "Cluster config:"
HOST_IP=`jq -r '.HOST_IP' config-cluster.json`
PORT=`jq -r '.PORT' config-cluster.json`
RAFT_PORT=`jq -r '.RAFT_PORT' config-cluster.json`
echo "HOST_IP=$HOST_IP"
echo "PORT=$PORT"
echo "RAFT_PORT=$RAFT_PORT"

echo '[' &>permissioned-nodes.json

PUBKEY=`bootnode -nodekey qdata/dd1/geth/nodekey -writeaddress`
ENODE_URL='enode://'"${PUBKEY}@${HOST_IP}:$((PORT))"'?discport=0&raftport='"$((RAFT_PORT))"
echo "  \"${ENODE_URL}\"," &>>permissioned-nodes.json

PUBKEY=`bootnode -nodekey qdata/dd2/geth/nodekey -writeaddress`
ENODE_URL='enode://'"${PUBKEY}@${HOST_IP}:$((PORT+1))"'?discport=0&raftport='"$((RAFT_PORT+1))"
echo "  \"${ENODE_URL}\"," &>>permissioned-nodes.json

PUBKEY=`bootnode -nodekey qdata/dd3/geth/nodekey -writeaddress`
ENODE_URL='enode://'"${PUBKEY}@${HOST_IP}:$((PORT+2))"'?discport=0&raftport='"$((RAFT_PORT+2))"
echo "  \"${ENODE_URL}\"," &>>permissioned-nodes.json

PUBKEY=`bootnode -nodekey qdata/dd4/geth/nodekey -writeaddress`
ENODE_URL='enode://'"${PUBKEY}@${HOST_IP}:$((PORT+3))"'?discport=0&raftport='"$((RAFT_PORT+3))"
echo "  \"${ENODE_URL}\"," &>>permissioned-nodes.json

PUBKEY=`bootnode -nodekey qdata/dd5/geth/nodekey -writeaddress`
ENODE_URL='enode://'"${PUBKEY}@${HOST_IP}:$((PORT+4))"'?discport=0&raftport='"$((RAFT_PORT+4))"
echo "  \"${ENODE_URL}\"," &>>permissioned-nodes.json

PUBKEY=`bootnode -nodekey qdata/dd6/geth/nodekey -writeaddress`
ENODE_URL='enode://'"${PUBKEY}@${HOST_IP}:$((PORT+5))"'?discport=0&raftport='"$((RAFT_PORT+5))"
echo "  \"${ENODE_URL}\"," &>>permissioned-nodes.json

PUBKEY=`bootnode -nodekey qdata/dd7/geth/nodekey -writeaddress`
ENODE_URL='enode://'"${PUBKEY}@${HOST_IP}:$((PORT+6))"'?discport=0&raftport='"$((RAFT_PORT+6))"
echo "  \"${ENODE_URL}\"" &>>permissioned-nodes.json

echo ']' &>>permissioned-nodes.json
