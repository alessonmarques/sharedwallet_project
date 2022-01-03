pragma solidity ^0.5.13;

import "Ownable.sol";

contract SimpleWallet is Ownable {

  function withdrawMoney(address payable _to, uint _amount) public onlyOwner {
    _to.transfer(_amount);
  }

  function () external payable {

  }

}