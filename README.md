# MS Blockchain Audit System
MS Blockchain Audit System with Quorum  

- How to start:  
`git clone https://github.com/cosimoth/MS_Audit_Sys.git`  
`cd MS_Audit_Sys`  
`sh ./init_env.sh`  
`./install_dep.sh`

- Start a cluster:  
`cd cluster`  
`./init_cluster.sh`  
start a cluster:  
`./start_cluster.sh`  
or start a permissioned cluster:  
`./start_cluster_permission.sh`

- Start a node:  
`cd node`  
`./gene_key.sh`  
Then get RAFT ID and edit "config.json"  
`./start_node.sh`  

- Stop a node
killall geth bootnode constellation-node
rm -rf MS_Audit_Sys .qdata
