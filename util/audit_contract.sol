pragma solidity ^0.4.15;

contract audit_store {
  string[] _data;
  string _info;
  address _customer;
  address _server=0xed9d02e382b34818e88b88a309c7fe71e65f419d;
  
  constructor(string info, address customer) public {
    _info=info;
    _customer=customer;
  }

  function put(string record) returns (string log) {
    if(msg.sender!=_customer && msg.sender!=_server)
      return "Permission denied";
    _data.push(record);
    return "Record written";
  }

  function get_record(uint idx) constant returns (string retVal) {
    if(msg.sender!=_customer && msg.sender!=_server)
      return "Permission denied";
    return _data[idx];
  }
  
  function get_num() constant returns (uint num) {
    if(msg.sender!=_customer)
      return 0;
    return _data.length;
  }
  
  function get_info() constant returns (string info) {
    if(msg.sender!=_customer && msg.sender!=_server)
      return "Permission denied";
    return _info;
  }
  
  function get_customer() constant returns (address customer) {
    return _customer;
  }
}
