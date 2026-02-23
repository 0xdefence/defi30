// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GovernorTimelockBypass {
    address public gov;
    uint256 public timelock = 2 days;
    mapping(bytes32 => uint256) public eta;

    constructor() {
        gov = msg.sender;
    }

    function queue(bytes32 actionId) external {
        require(msg.sender == gov, "not gov");
        eta[actionId] = block.timestamp + timelock;
    }

    // starter vulnerability: no timelock check before execute
    function execute(bytes32 actionId) external {
        require(msg.sender == gov, "not gov");
        require(eta[actionId] != 0, "not queued");
        // missing: require(block.timestamp >= eta[actionId])
        eta[actionId] = 0;
    }
}
