// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract C4PermitDomain { mapping(bytes32=>bool) public used; function permit(bytes32 d, bytes calldata) external { require(!used[d], "used"); used[d]=true; } }
