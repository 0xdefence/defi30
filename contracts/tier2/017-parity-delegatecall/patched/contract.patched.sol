// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ParityDelegatecallPatched {
    address public immutable lib;
    address public owner;
    bool public initialized;

    constructor(address _lib) {
        lib = _lib;
    }

    function init(address _owner) external {
        require(!initialized, "already initialized");
        initialized = true;
        owner = _owner;
    }

    function execute(address target, bytes calldata data) external {
        require(msg.sender == owner, "not owner");
        (bool ok, ) = target.call(data);
        require(ok, "call failed");
    }

    fallback() external payable {
        revert("no broad delegatecall fallback");
    }
}
