# Blockchain Audit System
Blockchain Audit System with Quorum  

## Environment  
Operating system:  
Ubuntu 16.04
Software version:   
golang 1.9.3, geth 1.7.2 

## Flowchart  
[avatar](https://github.com/cosimoth/Distributed_Audit/blob/master/chart.jpg)

## Install dependency  
```sh
git clone https://github.com/cosimoth/Distributed_Audit.git 
cd Distributed_Audit
sh ./init_env.sh
./install_dep.sh
```

## Start a cluster  
```sh
cd cluster
./init_cluster.sh
./start_cluster.sh
```

### Note:  
Before starting a cluster, all configurations should be checked in file "config-cluster.json", including IP addresses and ports.  
Since the cluster needs to be established on one VM, it should own seven different IP addresses to start Constellation nodes.  
We suppose these IP addresses are continuous, share a HOST_IP_BASE and start with a HOST_IP_OFFSET (defined in "config-cluster.json"). Main IP address is `$HOST_IP`, others are `${HOST_IP_BASE}${HOST_IP_OFFSET}`, `${HOST_IP_BASE}$((HOST_IP_OFFSET+1))`, ..., `${HOST_IP_BASE}$((HOST_IP_OFFSET+5))`, respectively.  
Azure VM IP configuration Setting:
1. Azure -> VM -> Network Interface  
2. Enable IP forwarding  
3. Add IP configuration with a Static IP address  
4. Add IP addresses to VM OS follw this [document](https://docs.microsoft.com/zh-cn/azure/virtual-network/virtual-network-multiple-ip-addresses-portal#os-config).  


## Start a node  
```sh
cd node
# Check configurations in file "config.json", including IP addresses and ports
./gene_key.sh
# Store password in ../pw.dat for convinence
# 
./start_node.sh [arguments]
```

## Stop a node  
```sh
killall geth constellation-node
rm -rf Distributed_Audit .qdata
```

## Write and read 
`cd util`  
Check configurations in `config-util.json`  
Get help:
`./run.sh -help`  
Show block number:  
`./run.sh -block`  
Show peer number:  
`./run.sh -peer --num` 
Add a new peer:
`./run.sh -peer --add <peer_identity>`  
Write audit record:   
`./run.sh -write <customer_name> <audit_record>`  
Read audit record:  
`./run.sh -read <customer_name>`    
