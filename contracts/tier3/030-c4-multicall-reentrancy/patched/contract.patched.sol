// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract C4MulticallReentrancyPatched { uint256 public n; bool locked; modifier nr(){require(!locked, "reentrant"); locked=true; _; locked=false;} function inc() external { n++; } function multicall(bytes[] calldata data) external nr { for(uint256 i;i<data.length;i++){ (bool ok,)=address(this).delegatecall(data[i]); require(ok); } } }
