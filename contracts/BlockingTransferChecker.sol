/*
This contract implements the ITransferChecker interface.
It's a minimal implementations blocking all of the transfer.
*/

pragma solidity ^0.5.2;

import 'openzeppelin-solidity/contracts/token/ERC20/ERC20.sol';
import './BaseTransferChecker.sol';


contract BlockingTransferChecker is BaseTransferChecker {

    function canTransfer(ERC20 token, address from, address to, uint256 value) public view returns(bool) {
        return false;
    }
}
