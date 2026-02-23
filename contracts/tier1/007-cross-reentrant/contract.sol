// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IHook {
    function onWithdraw(address user, uint256 amount) external;
}

contract CrossReentrant {
    mapping(address => uint256) public balance;
    IHook public hook;

    function setHook(address h) external {
        hook = IHook(h);
    }

    function deposit() external payable {
        balance[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) external {
        require(balance[msg.sender] >= amount, "insufficient");
        // external callback before state update (cross-contract reentrancy surface)
        if (address(hook) != address(0)) hook.onWithdraw(msg.sender, amount);
        (bool ok,) = msg.sender.call{value: amount}("");
        require(ok, "send failed");
        balance[msg.sender] -= amount;
    }
}
