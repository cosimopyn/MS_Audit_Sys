#!/bin/bash
PRIVATE_CONFIG=qdata/con/tm.ipc geth --exec "loadScript(\"$1\")" attach ipc:qdata/dd/geth.ipc
