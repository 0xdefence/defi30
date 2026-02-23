// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ProxyCollision {
    // slot 0
    address public implementation;
    // slot 1
    address public owner;

    constructor(address impl) {
        implementation = impl;
        owner = msg.sender;
    }

    function upgradeTo(address impl) external {
        require(msg.sender == owner, "not owner");
        implementation = impl;
    }

    fallback() external payable {
        // starter vulnerability: unrestricted delegatecall to implementation
        (bool ok, ) = implementation.delegatecall(msg.data);
        require(ok, "delegatecall failed");
    }
}
