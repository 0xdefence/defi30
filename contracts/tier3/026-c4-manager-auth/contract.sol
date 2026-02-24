// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract C4ManagerAuth { address public owner=msg.sender; address public manager; function setManager(address m) external { manager=m; } }
