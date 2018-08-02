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

  function put(string record) returns (string retVal) {
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
  
  function get_num() constant returns (string num) {
    if(msg.sender!=_customer)
      return "Permission denied";
    return uintToString(_data.length);
  }
  
  function get_info() constant returns (string info) {
    if(msg.sender!=_customer && msg.sender!=_server)
      return "Permission denied";
    return _info;
  }
  
  function get_customer() constant returns (address customer) {
    return _customer;
  }
  
  function uintToString(uint v) constant returns (string str) {
        uint maxlength = 100;
        bytes memory reversed = new bytes(maxlength);
        uint i = 0;
        while (v != 0) {
            uint remainder = v % 10;
            v = v / 10;
            reversed[i++] = byte(48 + remainder);
        }
        bytes memory s = new bytes(i + 1);
        for (uint j = 0; j <= i; j++) {
            s[j] = reversed[i - j];
        }
        str = string(s);
    }
}
