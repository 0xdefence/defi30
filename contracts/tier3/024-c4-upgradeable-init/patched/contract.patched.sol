// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract C4UpgradeableInitPatched { bool public initialized; address public owner; function initialize(address o) external { require(!initialized, "already initialized"); initialized=true; owner=o; } }
