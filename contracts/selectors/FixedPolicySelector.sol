pragma solidity ^0.5.2;

import './IPolicySelector.sol';
import '../TransferPolicy.sol';

/*
This contract is a stub implementation of a policy selector returning always a single policy.
*/
contract FixedPolicySelector is IPolicySelector {

    TransferPolicy fixedPolicy;

    constructor(TransferPolicy policy) public {
        fixedPolicy = policy;
    }

    /**
     * Returns always a fixed policy
     */
    function selectPolicy(address sender) external view returns(TransferPolicy) {
        return fixedPolicy;
    }

}
