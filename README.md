# MS Blockchain Audit System
MS Blockchain Audit System with Quorum  

- How to start:  
`git clone https://github.com/cosimoth/MS_Audit_Sys.git`  
`cd MS_Audit_Sys`  
`sh ./init-env.sh`  
`./install-dep.sh`

- Start a cluster:  
`cd cluster`  
`./init-cluster.sh`  
start a cluster:  
`./start-cluster.sh`  
or start a permissioned cluster:  
`./start-cluster-permission.sh`

- Start a node:  
`cd node`  
`./gene-key.sh`  
Then get RAFT ID 
`./start-node.sh`  
