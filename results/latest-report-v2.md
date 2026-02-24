# 0xDefend Blind Evaluation Summary (v2)

**Date:** 2026-02-24T22:51:06Z
**Tool:** 0xDefend v2-blind-eval
**Scorer Mode:** strict

## Dataset

| Metric | Value |
|---|---|
| Total contracts analyzed | 30 |
| Total findings submitted | 45 |
| Tier 1 findings | 14 |
| Tier 2 findings | 18 |
| Tier 3 findings | 13 |

## Scorer Results

| Metric | Score |
|---|---|
| **Composite Score** | **54.55** |
| Detection Rate | 80.95% (34/42 ground truths matched) |
| Precision | 75.56% (34/45 submitted findings matched) |
| Severity Accuracy | 70.59% (24/34 matched findings had correct severity) |
| Exploit Success Rate | 0.00% (detect-only, no exploit validation) |
| Patch Success Rate | 0.00% (detect-only, no patch validation) |
| Brier Score | 0.2142 |
| Expected Calibration Error | 0.1918 |

## Per-Tier Breakdown

| Tier | Contracts | Ground Truth | Matched | Detection Rate |
|---|---|---|---|---|
| Tier 1 (Synthetic) | 10 | 12 | 12 | 100.00% |
| Tier 2 (Real Exploits) | 10 | 20 | 12 | 60.00% |
| Tier 3 (Public Audits) | 10 | 10 | 10 | 100.00% |

## Matched Contracts

| Contract | GT | Matched | Severity OK |
|---|---|---|---|
| 001-reentrancy-vault | 1 | 1 | 1/1 |
| 002-stale-oracle-vault | 1 | 1 | 1/1 |
| 004-oracle-staleness-admin | 2 | 2 | 2/2 |
| 005-flash-loan-liquidator | 1 | 1 | 1/1 |
| 006-governor-timelock-bypass | 1 | 1 | 1/1 |
| 007-cross-reentrant | 1 | 1 | 1/1 |
| 008-unchecked-approval-drain | 2 | 2 | 1/2 |
| 009-proxy-collision | 1 | 1 | 0/1 |
| 010-initializer-exposed | 2 | 2 | 0/2 |
| 012-beanstalk-governance | 2 | 2 | 1/2 |
| 013-cream-callback | 2 | 1 | 1/1 |
| 014-ronin-access-control | 2 | 1 | 0/1 |
| 015-nomad-initialization | 2 | 1 | 1/1 |
| 016-mango-oracle | 2 | 1 | 1/1 |
| 017-parity-delegatecall | 2 | 2 | 2/2 |
| 018-badger-approval | 2 | 2 | 2/2 |
| 019-harvest-price-manipulation | 2 | 1 | 1/1 |
| 020-wormhole-signature | 2 | 1 | 1/1 |
| 021-c4-reward-reentrancy | 1 | 1 | 1/1 |
| 022-c4-oracle-decimals | 1 | 1 | 0/1 |
| 023-c4-signature-replay | 1 | 1 | 1/1 |
| 024-c4-upgradeable-init | 1 | 1 | 1/1 |
| 025-c4-rounding-drift | 1 | 1 | 1/1 |
| 026-c4-manager-auth | 1 | 1 | 1/1 |
| 027-c4-oracle-window | 1 | 1 | 0/1 |
| 028-c4-permit-domain | 1 | 1 | 0/1 |
| 029-c4-withdraw-queue-dos | 1 | 1 | 1/1 |
| 030-c4-multicall-reentrancy | 1 | 1 | 0/1 |

## Missed Contracts (0 matches)

011

## Remaining Gaps

| Contract | GT Class | Submitted Class | Issue |
|---|---|---|---|
| 011-euler-exchange-rate | price-manipulation + flash-loan | price-manipulation (donate) + reentrancy (borrow) | Location mismatch (donate vs collateralValue); class mismatch (reentrancy vs flash-loan) |
| 013-cream-callback VULN-002 | access-control | (not submitted) | Missing secondary finding |
| 014-ronin-access-control VULN-002 | signature-verification | access-control (setThreshold) | Class mismatch |
| 015-nomad-initialization VULN-002 | access-control | (not submitted) | Missing secondary finding |
| 016-mango-oracle VULN-002 | price-manipulation | (not submitted) | Missing secondary finding |
| 019-harvest VULN-001 | oracle-manipulation at spot() | price-manipulation at deposit() | Class + location mismatch |
| 020-wormhole VULN-002 | access-control | signature-verification (cross-chain) | Class mismatch |

## Blind Compliance

- **Compliant:** YES
- All 30 ground-truth.json files renamed to .hidden before analysis
- 0 ground-truth.json files accessible during analysis
- All 30 ground-truth.json files restored before scoring
- Analysis performed by 6 parallel Claude Opus 4.6 agents reading only contract.sol
- Ground truth hidden at 2026-02-24T22:43:59Z, restored at 2026-02-24T22:51:06Z
