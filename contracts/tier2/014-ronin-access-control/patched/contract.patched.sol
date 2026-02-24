// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract RoninAccessControlPatched {
    address public owner;
    uint256 public threshold;
    uint256 public immutable minThreshold;
    mapping(address => bool) public validator;
    mapping(bytes32 => bool) public executed;

    constructor(address[] memory initialValidators, uint256 initialThreshold) {
        owner = msg.sender;
        for (uint256 i = 0; i < initialValidators.length; i++) validator[initialValidators[i]] = true;
        threshold = initialThreshold;
        minThreshold = initialThreshold;
    }

    function setThreshold(uint256 t) external {
        require(msg.sender == owner, "not owner");
        require(t >= minThreshold, "cannot lower threshold");
        threshold = t;
    }

    function executeTransfer(bytes32 transferId, address to, uint256 amount, address[] calldata signers) external {
        require(!executed[transferId], "already executed");
        uint256 valid;
        for (uint256 i = 0; i < signers.length; i++) if (validator[signers[i]]) valid++;
        require(valid >= threshold, "insufficient signatures");
        executed[transferId] = true;
        (bool ok,) = to.call{value: amount}("");
        require(ok, "send failed");
    }

    receive() external payable {}
}
