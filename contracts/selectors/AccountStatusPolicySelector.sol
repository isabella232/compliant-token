pragma solidity ^0.5.2;

import './IPolicySelector.sol';
import '../TransferPolicy.sol';

/*
The contract enables user to define multiple compliance policies for different user groups,
like accredited investors and normal users.
*
This contract implements a selector based on accounts statuses.
It stores the relationship between an address and it's status and mapping between a status and policy.
It also defines a default policy for unclassified addresses.
*/
contract AccountStatusPolicySelector is IPolicySelector {

    address public operator;
    mapping(address => string) private statusForAddress;
    mapping(string => TransferPolicy) private policyForStatus;


    /**
     * Emitted when a new policy is set for a given status
     */
    event UpdatedPolicyForStatus(string indexed status, TransferPolicy indexed policy);

    /**
     * Emitted when a user account receives a new status
     */
    event UpdatedStatusForAccount(address indexed user, string indexed status);


    modifier onlyOperator() {
        require(msg.sender == operator, "Caller is not an operator");
        _;
    }

    constructor(TransferPolicy defaultPolicy) public {
        policyForStatus[''] = defaultPolicy;
        operator = msg.sender;
    }


    /**
     * Sets a policy for all of the account with a given status
     */
    function setPolicyForStatus(string memory status, TransferPolicy policy) public onlyOperator {
        policyForStatus[status] = policy;
        emit UpdatedPolicyForStatus(status, policy);
    }


    /**
     * Sets status for a given user address
     */
    function setStatusForAccount(address user, string memory status) public onlyOperator {
        statusForAddress[user] = status;
        emit UpdatedStatusForAccount(user, status);
    }


    /**
     * Returns always a fixed policy
     */
    function selectPolicy(address sender) external view returns(TransferPolicy) {
        string memory status = statusForAddress[sender];
        return policyForStatus[status];
    }

    /**
     * Returns a status of a given address
     */
    function getStatusOfAddress(address sender) external view returns(string memory) {
        return statusForAddress[sender];
    }


    /**
     * Returns a policy for a given address status
     */
    function getPolicyForStatus(string memory status) public view returns(TransferPolicy) {
        return policyForStatus[status];
    }



}
