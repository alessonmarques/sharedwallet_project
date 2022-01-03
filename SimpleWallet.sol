pragma solidity ^0.5.13;

import "Ownable.sol";

contract SimpleWallet is Ownable {

  mapping (address => uint) public allowance;

  function addAllowance(address _who, uint _amount) public onlyOwner {
    allowance[_who] = _amount;
  }

  modifier isAllowed(uint _amount) {
    require(isOwner() || allowance[msg.sender] >= _amount, "You are now allowed to do this.");
    _;
  }

  function reduceAllowance(address _who, uint _amount) internal {
    allowance[_who] -= _amount;
  }

  function withdrawMoney(address payable _to, uint _amount) public isAllowed(_amount) {
    require(_amount <= address(this).balance, "There are not enough funds stroed in this contract.");
    if (!isOwner()) {
      reduceAllowance(msg.sender, _amount);
    }
    _to.transfer(_amount);
  }

  function () external payable {

  }

}