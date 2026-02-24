# Tier3 Source Mapping

This document maps each Tier3 seed case to public source material and the benchmark ground-truth abstraction used in DeFi-30.

> Note: Tier3 cases are minimalized reproductions of public-audit/public-incident patterns for benchmark determinism.

## 021 — c4-reward-reentrancy
- Public reference:
  - https://code4rena.com/reports
  - https://swcregistry.io/docs/SWC-107
- Ground-truth mapping:
  - `VULN-001` → `reentrancy` in `claim()` (external call before state update)

## 022 — c4-oracle-decimals
- Public reference:
  - https://code4rena.com/reports
  - https://consensys.github.io/smart-contract-best-practices/development-recommendations/precautions/oracle-manipulation/
- Ground-truth mapping:
  - `VULN-001` → `precision-loss` in `collateralValue(address)` (decimal mismatch)

## 023 — c4-signature-replay
- Public reference:
  - https://code4rena.com/reports
  - https://eips.ethereum.org/EIPS/eip-712
- Ground-truth mapping:
  - `VULN-001` → `signature-verification` in `execute(address,uint256,bytes32,bytes)` (replay guard missing)

## 024 — c4-upgradeable-init
- Public reference:
  - https://code4rena.com/reports
  - https://docs.openzeppelin.com/upgrades-plugins/writing-upgradeable
- Ground-truth mapping:
  - `VULN-001` → `initialisation` in `initialize(address)` (re-initialization takeover)

## 025 — c4-rounding-drift
- Public reference:
  - https://code4rena.com/reports
  - https://secureum.substack.com/p/security-pitfalls-in-solidity-precision
- Ground-truth mapping:
  - `VULN-001` → `precision-loss` in `mintShares(uint256)` (rounding drift)

## 026 — c4-manager-auth
- Public reference:
  - https://code4rena.com/reports
  - https://swcregistry.io/docs/SWC-105
- Ground-truth mapping:
  - `VULN-001` → `access-control` in `setManager(address)` (missing auth)

## 027 — c4-oracle-window
- Public reference:
  - https://code4rena.com/reports
  - https://docs.uniswap.org/concepts/protocol/oracle
- Ground-truth mapping:
  - `VULN-001` → `oracle-manipulation` in `readPrice()` (single-spot usage)

## 028 — c4-permit-domain
- Public reference:
  - https://code4rena.com/reports
  - https://eips.ethereum.org/EIPS/eip-2612
- Ground-truth mapping:
  - `VULN-001` → `signature-verification` in `permit(bytes32,bytes)` (domain separation gap)

## 029 — c4-withdraw-queue-dos
- Public reference:
  - https://code4rena.com/reports
  - https://swcregistry.io/docs/SWC-128
- Ground-truth mapping:
  - `VULN-001` → `denial-of-service` in `process(uint256)` (unbounded loop)

## 030 — c4-multicall-reentrancy
- Public reference:
  - https://code4rena.com/reports
  - https://swcregistry.io/docs/SWC-107
- Ground-truth mapping:
  - `VULN-001` → `reentrancy` in `multicall(bytes[])` (stateful re-entry surface)
