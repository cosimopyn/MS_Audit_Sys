# Multiple-Nodes Cluster on Single VM
Cluster needs to own multiple IP addresses to start Constellation nodes.  
One IP address would cause HandShake errors.  
In this case, "permissioned-nodes.json" and "static-nodes.json" only list the IP address of Node 1.  
We use `HOST_IP_BASE` and `HOST_IP_OFFSET` in "config-cluster.json" to define these IP addresses.  

VM IP configuration Setting:  
1. Azure -> VM -> Network Interface  
2. Enable IP forwarding  
3. Add IP configuration with a Static IP address
4. Add IP addresses to VM OS 
https://docs.microsoft.com/zh-cn/azure/virtual-network/virtual-network-multiple-ip-addresses-portal#os-config
