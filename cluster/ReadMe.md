# Multiple-Nodes Cluster on Single VM
Cluster needs to own multiple IPs to start Constellation nodes.  
One IP would cause HandShake errors.  
In this case, "permissioned-nodes.json" and "static-nodes.json" only list IP of Node 1.  
We use `HOST_IP_BASE` and `HOST_IP_OFFSET` in "config-cluster.json" to define these IPs.  

VM IP configuration Setting:  
1. Azure -> VM -> Network Interface  
2. Enable IP forwarding  
3. Add IP configuration  
