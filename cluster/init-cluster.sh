#!/bin/bash

echo "Cleaning up temporary data directories..."
killall geth bootnode constellation-node
rm -rf qdata
mkdir -p qdata/logs

echo "Configuring node 1 (permissioned)..."
mkdir -p qdata/dd1/keystore
mkdir -p qdata/dd1/geth
cp keys/key1 qdata/dd1/keystore
cp raft/nodekey1 qdata/dd1/geth/nodekey

echo "Configuring node 2 (permissioned)..."
mkdir -p qdata/dd2/keystore
mkdir -p qdata/dd2/geth
cp keys/key2 qdata/dd2/keystore
cp raft/nodekey2 qdata/dd2/geth/nodekey

echo "Configuring node 3 (permissioned)..."
mkdir -p qdata/dd3/keystore
mkdir -p qdata/dd3/geth
cp keys/key6 qdata/dd3/keystore
cp keys/key3 qdata/dd3/keystore
cp raft/nodekey3 qdata/dd3/geth/nodekey

echo "Configuring node 4 (permissioned)..."
mkdir -p qdata/dd4/keystore
mkdir -p qdata/dd4/geth
cp keys/key4 qdata/dd4/keystore
cp raft/nodekey4 qdata/dd4/geth/nodekey

echo "Configuring node 5..."
mkdir -p qdata/dd5/keystore
mkdir -p qdata/dd5/geth
cp keys/key5 qdata/dd5/keystore
cp raft/nodekey5 qdata/dd5/geth/nodekey

echo "Configuring node 6..."
mkdir -p qdata/dd6/keystore
mkdir -p qdata/dd6/geth
cp raft/nodekey6 qdata/dd6/geth/nodekey
cp keys/key7 qdata/dd6/keystore

echo "Configuring node 7..."
mkdir -p qdata/dd7/keystore
mkdir -p qdata/dd7/geth
cp raft/nodekey7 qdata/dd7/geth/nodekey
cp keys/key8 qdata/dd7/keystore

echo "Generating enode urls..."
touch permissioned-nodes.json
./gene-enodes.sh

echo "Init nodes..."
cp permissioned-nodes.json qdata/dd1/static-nodes.json
cp permissioned-nodes.json qdata/dd1/
geth --datadir qdata/dd1 init ../genesis.json

cp permissioned-nodes.json qdata/dd2/static-nodes.json
cp permissioned-nodes.json qdata/dd2/
geth --datadir qdata/dd2 init ../genesis.json

cp permissioned-nodes.json qdata/dd3/static-nodes.json
cp permissioned-nodes.json qdata/dd3/
geth --datadir qdata/dd3 init ../genesis.json

cp permissioned-nodes.json qdata/dd4/static-nodes.json
cp permissioned-nodes.json qdata/dd4/
geth --datadir qdata/dd4 init ../genesis.json

cp permissioned-nodes.json qdata/dd5/static-nodes.json
geth --datadir qdata/dd5 init ../genesis.json

cp permissioned-nodes.json qdata/dd6/static-nodes.json
geth --datadir qdata/dd6 init ../genesis.json

cp permissioned-nodes.json qdata/dd7/static-nodes.json
geth --datadir qdata/dd7 init ../genesis.json
