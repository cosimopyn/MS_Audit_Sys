var mess = "12";
var address = "xxx";

web3.eth.defaultAccount = eth.accounts[0];
var abi = [{"constant":true,"inputs":[{"name":"idx","type":"uint256"}],"name":"get_record","outputs":[{"name":"retVal","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"get_num","outputs":[{"name":"num","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"record","type":"string"}],"name":"put","outputs":[{"name":"retVal","type":"string"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"get_info","outputs":[{"name":"info","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"get_customer","outputs":[{"name":"customer","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[{"name":"info","type":"string"},{"name":"customer","type":"address"}],"payable":false,"stateMutability":"nonpayable","type":"constructor"}];

var simpleContract = web3.eth.contract(abi);
var simple = simpleContract.at(address);

simple.put(mess);
console.log(simple.address);
