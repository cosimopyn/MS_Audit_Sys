pragma solidity ^0.4.15;

contract audit_store {
  string[] public _data;
  string public _info;
  
  constructor(string info) {
    _info=info;
  }

  function put(string record) {
    _data.push(record);
  }

  function get_record(uint idx) constant returns (string retVal) {
    return _data[idx];
  }
  
  function get_num() constant returns (uint num) {
    return _data.length;
  }
  
  function get_info() constant returns (string info) {
    return _info;
  }
}
