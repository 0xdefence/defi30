// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract C4RoundingDrift { uint256 public totalAssets=1e18; uint256 public totalShares=1e18; function mintShares(uint256 assets) external view returns(uint256){ return (assets*totalShares)/(totalAssets+1); } }
