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

contract SimpleWallet is Allowance {

  event MoneySent(address indexed _beneficiary, uint _amount);
  event MoneyReceived(address indexed _from, uint _amount);

  function withdrawMoney(address payable _to, uint _amount) public isAllowed(_amount) {
    require(_amount <= address(this).balance, "There are not enough funds stroed in this contract.");
    if (!isOwner()) {
      reduceAllowance(msg.sender, _amount);
    }
    emit MoneySent(_to, _amount);
    _to.transfer(_amount);
  }

  function () external payable {
    emit MoneyReceived(msg.sender, msg.value);
  }

}