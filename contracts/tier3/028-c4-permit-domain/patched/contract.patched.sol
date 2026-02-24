// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract C4PermitDomainPatched { mapping(bytes32=>bool) public used; function permit(bytes32 d, bytes calldata, uint256 chainId, address verifying) external { bytes32 dd=keccak256(abi.encode(chainId, verifying, d)); require(!used[dd], "used"); used[dd]=true; } }
