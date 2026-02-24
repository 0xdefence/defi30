// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract NomadInitializationPatched {
    bytes32 public trustedRoot;
    bool public initialized;
    address public owner;

    function initialize(bytes32 _trustedRoot, address _owner) external {
        require(!initialized, "already initialized");
        require(_trustedRoot != bytes32(0), "zero root");
        require(_owner != address(0), "owner=0");
        trustedRoot = _trustedRoot;
        owner = _owner;
        initialized = true;
    }

    function process(bytes32 messageHash, bytes32 root) external view {
        require(initialized, "not initialized");
        require(root == trustedRoot, "invalid root");
        require(messageHash != bytes32(0), "bad message");
    }
}
