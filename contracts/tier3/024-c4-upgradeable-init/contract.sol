// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract C4UpgradeableInit { bool public initialized; address public owner; function initialize(address o) external { owner=o; initialized=true; } }
