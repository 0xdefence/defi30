// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract C4WithdrawQueueDos { uint256[] public q; function enqueue(uint256 x) external { q.push(x);} function process(uint256 n) external view returns(uint256 s){ for(uint256 i;i<n;i++) s+=q[i]; }}
