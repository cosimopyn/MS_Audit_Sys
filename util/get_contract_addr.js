/*
A Java script template to use a transaction hash to get the address of an existing contract
It is called in the "read_data.func"
geth --exec "loadScript(\"get_contract_addr.js\") ..."
which utilizes geth command to attach the node IPC and execute the script
*/

var TXNHash = "<Transaction_Hash>";

console.log(eth.getTransactionReceipt(TXNHash).contractAddress);
