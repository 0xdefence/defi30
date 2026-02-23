// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * Minimal recreation of unsafe bridge initialization pattern.
 *
 * Core bug: initializer can be called without one-time guard,
 * and accepts an unvalidated trusted root (including zero root).
 */
contract NomadInitialization {
    bytes32 public trustedRoot;
    bool public initialized;
    address public owner;

    mapping(bytes32 => bool) public proven;

    event Initialized(address indexed by, bytes32 root);
    event OwnerChanged(address indexed newOwner);
    event Processed(bytes32 indexed messageHash);

    // Vulnerable: callable multiple times; no only-once initializer guard.
    function initialize(bytes32 _trustedRoot, address _owner) external {
        // Vulnerable: accepts zero root (or otherwise untrusted root) directly.
        trustedRoot = _trustedRoot;
        owner = _owner;
        initialized = true;
        emit Initialized(msg.sender, _trustedRoot);
    }

    // Simulated proof check path.
    function process(bytes32 messageHash, bytes32 root) external {
        require(initialized, "not initialized");
        require(root == trustedRoot, "invalid root");
        require(!proven[messageHash], "already processed");

        proven[messageHash] = true;
        emit Processed(messageHash);
    }

    function setOwner(address _owner) external {
        require(msg.sender == owner, "not owner");
        owner = _owner;
        emit OwnerChanged(_owner);
    }
}
