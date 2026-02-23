# 012 — Beanstalk Governance Flash-Loan Pattern (Minimal Recreation)

## Pattern summary
This case models governance capture through temporary voting power and immediate execution.

## Vulnerable chain
1. Attacker obtains short-lived governance tokens (e.g., via flash liquidity).
2. `vote()` reads **current** balance (no snapshot), so temporary balance counts.
3. `execute()` can run immediately once quorum is met.

## Why detection should succeed
A capable detector should identify:
- governance vote accounting based on non-snapshotted balance;
- missing timelock between proposal passing and execution.

## Expected findings
- critical governance finding in `vote(uint256)`
- critical governance finding in `execute(uint256)`

## Defensive controls
- block-based snapshots for voting power
- proposal execution timelock
- quorum sanity checks vs circulating supply
- emergency veto/guardian path
