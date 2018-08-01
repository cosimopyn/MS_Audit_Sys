# Blockchain Audit System
Blockchain Audit System with Quorum  

- How to start:  
`git clone https://github.com/cosimoth/Distributed_Audit.git`  
`cd Distributed_Audit`  
`sh ./init_env.sh`  
`./install_dep.sh`

- Start a cluster:  
`cd cluster`  
`./init_cluster.sh`  
start a normal cluster:  
`./start_cluster.sh`  
or start a permissioned cluster:  
`./start_cluster_permission.sh`

- Start a node:  
`cd node`  
`./gene_key.sh`  
Then get RAFT ID and edit "config.json"  
`./start_node.sh`  

- Stop a node  
`killall geth bootnode constellation-node`  
`rm -rf Distributed_Audit .qdata`  
