// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IF27P{ function p() external view returns(uint256);} contract C4OracleWindowPatched { IF27P public f; uint256 public last; constructor(address a){f=IF27P(a);} function sync() external { uint256 p=f.p(); require(last==0 || (p*100<=last*120 && p*100>=last*80), "deviation"); last=p; } function readPrice() external view returns(uint256){ return last; }}
