// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract C4RewardReentrancy {
    mapping(address => uint256) public reward;

    function fund(address user) external payable {
        reward[user] += msg.value;
    }

    function claim() external {
        uint256 amt = reward[msg.sender];
        require(amt > 0, "no reward");
        (bool ok,) = msg.sender.call{value: amt}("");
        require(ok, "send failed");
        // vulnerable: state update after interaction
        reward[msg.sender] = 0;
    }
}
