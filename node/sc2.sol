pragma solidity ^0.4.15;

contract simple {
  string[] public _dataStore;
  string public _info;
  
  constructor(string info) public {
    _info=info;
  }

  function put(string record) public {
    _dataStore.push(record);
  }

  function get_record(uint idx) constant public returns (string retVal) {
    return _dataStore[idx];
  }
  
  function get_num() constant public returns (uint num) {
    return _dataStore.length;
  }
  
  function get_info() constant public returns (string info) {
    return _info;
  }
}
