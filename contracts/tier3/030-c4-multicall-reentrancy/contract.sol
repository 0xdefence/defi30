// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract C4MulticallReentrancy { uint256 public n; function inc() external { n++; } function multicall(bytes[] calldata data) external { for(uint256 i;i<data.length;i++){ (bool ok,)=address(this).delegatecall(data[i]); require(ok); } } }
