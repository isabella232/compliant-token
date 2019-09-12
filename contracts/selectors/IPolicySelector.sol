pragma solidity ^0.5.2;

import '../TransferPolicy.sol';

/*
This interface defines how the compliant wrapper may choose an appropriate policy.
The policy is selected based on an account allowing token transfer to fulfill checks
based on account status (accredited investors) or location (jurisdiction).
*/
interface IPolicySelector {

    /**
     * Returns a policy appropriate for a given account
     */
    function selectPolicy(address sender) external view returns(TransferPolicy);

}
