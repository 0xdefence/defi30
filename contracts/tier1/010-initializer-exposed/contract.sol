// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract InitializerExposed {
    bool public initialized;
    address public owner;

    // starter vulnerability: callable multiple times and publicly accessible
    function initialize(address _owner) external {
        owner = _owner;
        initialized = true;
    }

    function privilegedAction() external view {
        require(msg.sender == owner, "not owner");
    }

    // starter vulnerability: tx.origin based authorization
    function emergencySetOwner(address _owner) external {
        require(tx.origin == owner, "origin auth failed");
        owner = _owner;
    }
}
