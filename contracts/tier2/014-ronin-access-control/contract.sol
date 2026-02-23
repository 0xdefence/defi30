// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * Minimal recreation of multisig threshold/access-control failure pattern.
 *
 * Core bug: bridge transfer execution validates signatures against an unsafe,
 * mutable threshold that can be lowered by owner, enabling insufficient signer execution.
 */
contract RoninAccessControl {
    address public owner;
    uint256 public threshold;

    mapping(address => bool) public validator;
    mapping(bytes32 => bool) public executed;

    event ValidatorSet(address indexed validator, bool allowed);
    event ThresholdChanged(uint256 threshold);
    event Executed(bytes32 indexed transferId, address indexed to, uint256 amount);

    constructor(address[] memory initialValidators, uint256 initialThreshold) {
        require(initialValidators.length > 0, "no validators");
        owner = msg.sender;
        for (uint256 i = 0; i < initialValidators.length; i++) {
            validator[initialValidators[i]] = true;
        }
        threshold = initialThreshold;
    }

    function setValidator(address v, bool ok) external {
        require(msg.sender == owner, "not owner");
        validator[v] = ok;
        emit ValidatorSet(v, ok);
    }

    // Vulnerable admin control: threshold can be set dangerously low without safeguards.
    function setThreshold(uint256 t) external {
        require(msg.sender == owner, "not owner");
        require(t > 0, "zero");
        threshold = t;
        emit ThresholdChanged(t);
    }

    function executeTransfer(
        bytes32 transferId,
        address to,
        uint256 amount,
        address[] calldata signers
    ) external {
        require(!executed[transferId], "already executed");
        require(to != address(0), "bad to");

        // Vulnerable verification: counts signer array entries and trusts mutable threshold.
        uint256 valid;
        for (uint256 i = 0; i < signers.length; i++) {
            if (validator[signers[i]]) {
                valid += 1;
            }
        }
        require(valid >= threshold, "insufficient signatures");

        executed[transferId] = true;
        (bool ok, ) = to.call{value: amount}("");
        require(ok, "send failed");

        emit Executed(transferId, to, amount);
    }

    receive() external payable {}
}
