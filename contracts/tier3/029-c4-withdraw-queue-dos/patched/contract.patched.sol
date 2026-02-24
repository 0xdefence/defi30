// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract C4WithdrawQueueDosPatched { uint256[] public q; uint256 public constant MAX_BATCH=100; function enqueue(uint256 x) external { q.push(x);} function process(uint256 n) external view returns(uint256 s){ require(n<=MAX_BATCH, "batch too large"); for(uint256 i;i<n;i++) s+=q[i]; }}
