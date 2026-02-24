// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract C4RewardReentrancyPatched {
    mapping(address => uint256) public reward;
    bool private locked;

    function fund(address user) external payable { reward[user] += msg.value; }

    modifier nonReentrant() {
        require(!locked, "reentrant");
        locked = true;
        _;
        locked = false;
    }

    function claim() external nonReentrant {
        uint256 amt = reward[msg.sender];
        require(amt > 0, "no reward");
        reward[msg.sender] = 0;
        (bool ok,) = msg.sender.call{value: amt}("");
        require(ok, "send failed");
    }
}
