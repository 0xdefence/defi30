// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract InitializerExposedPatched {
    bool public initialized;
    address public owner;

    function initialize(address _owner) external {
        require(!initialized, "already initialized");
        require(_owner != address(0), "owner=0");
        owner = _owner;
        initialized = true;
    }

    function privilegedAction() external view {
        require(msg.sender == owner, "not owner");
    }

    function emergencySetOwner(address _owner) external {
        require(msg.sender == owner, "not owner");
        owner = _owner;
    }
}
