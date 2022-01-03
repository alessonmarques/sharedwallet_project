
pragma solidity ^0.5.13;

import "Ownable.sol";
import "SafeMath.sol";

contract Allowance is Ownable {
  
  using SafeMath for uint;

  event AllowanceChanged(address indexed _forWho, address indexed _fromWhom, uint _oldAmount, uint _newAmount);

  mapping (address => uint) public allowance;

  modifier isAllowed(uint _amount) {
    require(isOwner() || allowance[msg.sender] >= _amount, "You are now allowed to do this.");
    _;
  }

  function addAllowance(address _who, uint _amount) public onlyOwner {
    emit AllowanceChanged(_who, msg.sender, allowance[_who], _amount);
    allowance[_who] = _amount;
  }

  function reduceAllowance(address _who, uint _amount) internal {
    emit AllowanceChanged(_who, msg.sender, allowance[_who], allowance[_who].sub(_amount));
    allowance[_who] = allowance[_who].sub(_amount);
  }

}