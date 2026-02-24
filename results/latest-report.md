# Benchmark Result: 0xDefend v2-blind-eval

- Timestamp: 2026-02-24T22:51:06Z
- Detection Rate: 80.95%
- Precision: 75.56%
- Severity Accuracy: 70.59%
- Exploit Success Rate: 0.00%
- Patch Success Rate: 0.00%
- Median Time to First Valid Exploit: n/as
- Brier Score (confidence): 0.2142
- Expected Calibration Error (ECE@10): 0.1918
- Composite Score: 54.55

| Contract | Tier | GT | Matched | Submitted | Precision-Matched | Severity Correct | Exploit | Patch | TTFV(s) |
|---|---:|---:|---:|---:|---:|---:|---|---|---:|
| 001-reentrancy-vault | 1 | 1 | 1 | 1 | 1 | 1 | fail | fail | - |
| 002-stale-oracle-vault | 1 | 1 | 1 | 1 | 1 | 1 | fail | fail | - |
| 003-clean-vault | 1 | 0 | 0 | 0 | 0 | 0 | n/a | n/a | - |
| 004-oracle-staleness-admin | 1 | 2 | 2 | 2 | 2 | 2 | fail | fail | - |
| 005-flash-loan-liquidator | 1 | 1 | 1 | 1 | 1 | 1 | n/a | n/a | - |
| 006-governor-timelock-bypass | 1 | 1 | 1 | 1 | 1 | 1 | n/a | n/a | - |
| 007-cross-reentrant | 1 | 1 | 1 | 2 | 1 | 1 | n/a | n/a | - |
| 008-unchecked-approval-drain | 1 | 2 | 2 | 2 | 2 | 1 | fail | fail | - |
| 009-proxy-collision | 1 | 1 | 1 | 2 | 1 | 0 | n/a | n/a | - |
| 010-initializer-exposed | 1 | 2 | 2 | 2 | 2 | 0 | fail | fail | - |
| 011-euler-exchange-rate | 2 | 2 | 0 | 2 | 0 | 0 | fail | fail | - |
| 012-beanstalk-governance | 2 | 2 | 2 | 2 | 2 | 1 | fail | fail | - |
| 013-cream-callback | 2 | 2 | 1 | 1 | 1 | 1 | fail | fail | - |
| 014-ronin-access-control | 2 | 2 | 1 | 2 | 1 | 0 | fail | fail | - |
| 015-nomad-initialization | 2 | 2 | 1 | 1 | 1 | 1 | fail | fail | - |
| 016-mango-oracle | 2 | 2 | 1 | 1 | 1 | 1 | fail | fail | - |
| 017-parity-delegatecall | 2 | 2 | 2 | 3 | 2 | 2 | fail | fail | - |
| 018-badger-approval | 2 | 2 | 2 | 2 | 2 | 2 | fail | fail | - |
| 019-harvest-price-manipulation | 2 | 2 | 1 | 2 | 1 | 1 | fail | fail | - |
| 020-wormhole-signature | 2 | 2 | 1 | 2 | 1 | 1 | fail | fail | - |
| 021-c4-reward-reentrancy | 3 | 1 | 1 | 1 | 1 | 1 | fail | fail | - |
| 022-c4-oracle-decimals | 3 | 1 | 1 | 2 | 1 | 0 | fail | fail | - |
| 023-c4-signature-replay | 3 | 1 | 1 | 2 | 1 | 1 | fail | fail | - |
| 024-c4-upgradeable-init | 3 | 1 | 1 | 1 | 1 | 1 | fail | fail | - |
| 025-c4-rounding-drift | 3 | 1 | 1 | 1 | 1 | 1 | fail | fail | - |
| 026-c4-manager-auth | 3 | 1 | 1 | 1 | 1 | 1 | fail | fail | - |
| 027-c4-oracle-window | 3 | 1 | 1 | 1 | 1 | 0 | fail | fail | - |
| 028-c4-permit-domain | 3 | 1 | 1 | 2 | 1 | 0 | fail | fail | - |
| 029-c4-withdraw-queue-dos | 3 | 1 | 1 | 1 | 1 | 1 | fail | fail | - |
| 030-c4-multicall-reentrancy | 3 | 1 | 1 | 1 | 1 | 0 | fail | fail | - |
