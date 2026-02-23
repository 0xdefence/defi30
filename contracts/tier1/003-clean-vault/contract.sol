// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CleanVault {
    mapping(address => uint256) public balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) external {
        uint256 bal = balances[msg.sender];
        require(bal >= amount, "insufficient");
        balances[msg.sender] = bal - amount;
        (bool ok,) = msg.sender.call{value: amount}("");
        require(ok, "send failed");
    }
}
