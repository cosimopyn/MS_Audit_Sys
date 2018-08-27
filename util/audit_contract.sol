pragma solidity ^0.4.15;

contract audit_store {
  string[] _data; // Dynamic array to store audit data
  string _info; // Information to describe this contract
  address _customer; // ID of this Customer 
  // ID of Audit Team is the address in $PROJ_HOME/cluster/keys/key1
  address constant _server=0xed9d02e382b34818e88b88a309c7fe71e65f419d;
  
  constructor(string info, address customer) public {
    // Initialize contract info and Customer ID
    _info=info;
    _customer=customer;
    // Once the contract is deployed, they cannot be modified.
  }

  function put(string record) public returns (string retVal) {
    // Only this Customer can write data
    if(msg.sender!=_customer)
      return "Permission denied";
    _data.push(record);
    return "Record written";
  }

  function get_record(uint idx) constant public returns (string retVal) {
    // Only this Customer and the Audit Team can write data
    if(msg.sender!=_customer && msg.sender!=_server)
      return "Permission denied";
    return _data[idx];
  }
  
  function get_num() constant public returns (uint num) {
    if(msg.sender!=_customer && msg.sender!=_server)
      return 0;
    return _data.length;
  }
  
  function get_info() constant public returns (string info) {
    if(msg.sender!=_customer && msg.sender!=_server)
      return "Permission denied";
    return _info;
  }
  
  function get_customer() constant public returns (address customer) {
    return _customer;
  }
  
}
