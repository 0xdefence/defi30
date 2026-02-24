// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IF27{ function p() external view returns(uint256);} contract C4OracleWindow { IF27 public f; constructor(address a){f=IF27(a);} function readPrice() external view returns(uint256){ return f.p(); }}
