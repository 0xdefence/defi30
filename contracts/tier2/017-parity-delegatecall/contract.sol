// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * 017 — Parity delegatecall pattern (minimal recreation)
 *
 * Vulnerable by design for benchmark purposes:
 *  - Proxy fallback blindly delegatecalls to shared library
 *  - Library init function can be called through proxy storage context
 */
contract ParityDelegatecall {
    address public lib;
    address public owner;

    event Executed(address indexed target, bytes data);

    constructor(address _lib) {
        lib = _lib;
    }

    function setLib(address _lib) external {
        // Intentionally unsafe: no access control to simplify benchmark signal
        lib = _lib;
    }

    function execute(address target, bytes calldata data) external {
        require(msg.sender == owner, "not owner");
        (bool ok, ) = target.call(data);
        require(ok, "call failed");
        emit Executed(target, data);
    }

    fallback() external payable {
        // Core Parity-style anti-pattern: broad delegatecall gateway
        address _lib = lib;
        assembly {
            calldatacopy(0, 0, calldatasize())
            let ok := delegatecall(gas(), _lib, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch ok
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }

    receive() external payable {}
}

contract WalletLibrary {
    address public owner;

    function initWallet(address _owner) external {
        // Intentionally vulnerable: initializer is callable multiple times.
        owner = _owner;
    }

    function kill() external {
        require(msg.sender == owner, "not owner");
        selfdestruct(payable(msg.sender));
    }
}
