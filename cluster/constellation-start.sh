#!/bin/bash

HOST_IP=`jq -r '.HOST_IP' config-cluster.json`
PORT=`jq -r '.PORT' config-cluster.json`
RAFT_PORT=`jq -r '.RAFT_PORT' config-cluster.json`
RPC_PORT=`jq -r '.RPC_PORT' config-cluster.json`
CONSTE_PORT=`jq -r '.CONSTE_PORT' config-cluster.json`

set -u
set -e

for i in {1..7}
do
    DDIR="qdata/c$i"
    mkdir -p $DDIR
    mkdir -p qdata/logs
    cp "keys/tm$i.pub" "$DDIR/tm.pub"
    cp "keys/tm$i.key" "$DDIR/tm.key"
    rm -f "$DDIR/tm.ipc"
    CUR_CONSTE_PORT=$((CONSTE_PORT-1+i))
    CMD="constellation-node --url=https://${HOST_IP}:900${CUR_CONSTE_PORT}/ --port=${CUR_CONSTE_PORT} --workdir=$DDIR --socket=tm.ipc --publickeys=tm.pub --privatekeys=tm.key --othernodes=https://${HOST_IP}:${CONSTE_PORT}/"
    echo "$CMD >> qdata/logs/constellation$i.log 2>&1 &"
    $CMD >> "qdata/logs/constellation$i.log" 2>&1 &
done

DOWN=true
while $DOWN; do
    sleep 0.1
    DOWN=false
    for i in {1..7}
    do
	if [ ! -S "qdata/c$i/tm.ipc" ]; then
            DOWN=true
	fi
    done
done
