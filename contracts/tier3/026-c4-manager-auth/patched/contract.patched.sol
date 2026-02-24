// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract C4ManagerAuthPatched { address public owner=msg.sender; address public manager; function setManager(address m) external { require(msg.sender==owner, "not owner"); manager=m; } }
