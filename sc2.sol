pragma solidity ^0.4.15;

contract sc2 {
  bytes32[] public dataStore;
  uint public idx;
 
  constructor(bytes32 initVal) {
    dataStore.push(initVal);
    idx=1;
  }

  function put(bytes32 x) {
    dataStore.push(x);
    idx = idx + 1;
  }

  function get() constant returns (bytes32 retVal) {
    return dataStore[idx];
  }
}
