#!/bin/bash

QDATA_DIR=`jq -r '.QDATA_DIR' ./config-cluster.json`

echo "Cleaning up temporary data directories..."
killall geth bootnode constellation-node
rm -rf ${QDATA_DIR}
mkdir -p ${QDATA_DIR}/logs

echo "Configuring node 1..."
mkdir -p ${QDATA_DIR}/dd1/keystore
mkdir -p ${QDATA_DIR}/dd1/geth
cp keys/key1 ${QDATA_DIR}/dd1/keystore
cp raft/nodekey1 ${QDATA_DIR}/dd1/geth/nodekey

echo "Configuring node 2..."
mkdir -p ${QDATA_DIR}/dd2/keystore
mkdir -p ${QDATA_DIR}/dd2/geth
cp keys/key2 ${QDATA_DIR}/dd2/keystore
cp raft/nodekey2 ${QDATA_DIR}/dd2/geth/nodekey

echo "Configuring node 3..."
mkdir -p ${QDATA_DIR}/dd3/keystore
mkdir -p ${QDATA_DIR}/dd3/geth
cp keys/key6 ${QDATA_DIR}/dd3/keystore
cp keys/key3 ${QDATA_DIR}/dd3/keystore
cp raft/nodekey3 ${QDATA_DIR}/dd3/geth/nodekey

echo "Configuring node 4..."
mkdir -p ${QDATA_DIR}/dd4/keystore
mkdir -p ${QDATA_DIR}/dd4/geth
cp keys/key4 ${QDATA_DIR}/dd4/keystore
cp raft/nodekey4 ${QDATA_DIR}/dd4/geth/nodekey

echo "Configuring node 5..."
mkdir -p ${QDATA_DIR}/dd5/keystore
mkdir -p ${QDATA_DIR}/dd5/geth
cp keys/key5 ${QDATA_DIR}/dd5/keystore
cp raft/nodekey5 ${QDATA_DIR}/dd5/geth/nodekey

echo "Configuring node 6..."
mkdir -p ${QDATA_DIR}/dd6/keystore
mkdir -p ${QDATA_DIR}/dd6/geth
cp raft/nodekey6 ${QDATA_DIR}/dd6/geth/nodekey
cp keys/key7 ${QDATA_DIR}/dd6/keystore

echo "Configuring node 7..."
mkdir -p ${QDATA_DIR}/dd7/keystore
mkdir -p ${QDATA_DIR}/dd7/geth
cp raft/nodekey7 ${QDATA_DIR}/dd7/geth/nodekey
cp keys/key8 ${QDATA_DIR}/dd7/keystore

echo "Generating enode urls..."
touch permissioned-nodes.json
./gene_enodes.sh

echo "Init nodes..."
cp permissioned-nodes.json ${QDATA_DIR}/dd1/static-nodes.json
cp permissioned-nodes.json ${QDATA_DIR}/dd1/
geth --datadir ${QDATA_DIR}/dd1 init ../genesis.json

cp permissioned-nodes.json ${QDATA_DIR}/dd2/static-nodes.json
cp permissioned-nodes.json ${QDATA_DIR}/dd2/
geth --datadir ${QDATA_DIR}/dd2 init ../genesis.json

cp permissioned-nodes.json ${QDATA_DIR}/dd3/static-nodes.json
cp permissioned-nodes.json ${QDATA_DIR}/dd3/
geth --datadir ${QDATA_DIR}/dd3 init ../genesis.json

cp permissioned-nodes.json ${QDATA_DIR}/dd4/static-nodes.json
cp permissioned-nodes.json ${QDATA_DIR}/dd4/
geth --datadir ${QDATA_DIR}/dd4 init ../genesis.json

cp permissioned-nodes.json ${QDATA_DIR}/dd5/static-nodes.json
geth --datadir ${QDATA_DIR}/dd5 init ../genesis.json

cp permissioned-nodes.json ${QDATA_DIR}/dd6/static-nodes.json
geth --datadir ${QDATA_DIR}/dd6 init ../genesis.json

cp permissioned-nodes.json ${QDATA_DIR}/dd7/static-nodes.json
geth --datadir ${QDATA_DIR}/dd7 init ../genesis.json
