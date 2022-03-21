//SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "./allowance.sol";

contract SharedWallet is Allowance {
    
    event MoneySent(address indexed _beneficiary, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount);

    function withdrawMoney(address payable _to, uint _amount) public ownerOrAllowed(_amount){
        //Checks contract balance for enough Ether
        require(_amount <= address(this).balance, "Contract doesn't own enough money");
        // IF not owner, reduce allowance for caller
        if(!isOwner()) {
            reduceAllowance(msg.sender, _amount);
        }
        emit MoneySent(_to, _amount);
        _to.transfer(_amount);
    }

    function renounceOwnership() public view override onlyOwner {
        revert("Can't renounce ownership");
    }

    receive () external payable {
        emit MoneyReceived(msg.sender, msg.value);
    }

}