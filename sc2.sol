pragma solidity ^0.4.15;

contract simplestorage {
  byte32[] public dataStore;
  uint public idx;
 
  public function constructor(byte32 initVal) {
    storedData = initVal;
    idx=1;
  }

  public function set(byte32 x) {
    storedData = x;
  }

  public function get() constant returns (uint retVal) {
    return storedData;
  }
}
