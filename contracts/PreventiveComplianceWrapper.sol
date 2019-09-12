/*
This contract wraps the standard ERC20 token mediating all of the transfer operation
to assure they are compliant with previously defined rules.
*/

pragma solidity ^0.5.2;

import 'openzeppelin-solidity/contracts/token/ERC20/ERC20.sol';
import './TransferPolicy.sol';
import './selectors/IPolicySelector.sol';


contract PreventiveComplianceWrapper is ERC20 {

    address public operator;
    IPolicySelector public policySelector;

    modifier onlyOperator() {
        require(msg.sender == operator, "Caller is not an operator");
        _;
    }

    constructor() public {
        operator = msg.sender;
    }

    function setPolicySelector(IPolicySelector _policySelector) public onlyOperator {
        policySelector = _policySelector;
    }

    /**
     * Wraps the transfer function delegating checks if the transaction is compliant
     */
    function transfer(address recipient, uint256 amount) public returns (bool) {
        TransferPolicy policy = policySelector.selectPolicy(msg.sender);
        require(policy.canTransfer(this, msg.sender, recipient, amount), 'Transfer is not compliant');
        bool executed =  super.transfer(recipient, amount);
        policy.notifyAfterTransfer(msg.sender, recipient, amount, executed);
        return executed;
    }

}
