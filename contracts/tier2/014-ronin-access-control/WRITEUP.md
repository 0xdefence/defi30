# 014 — Ronin Access-Control / Threshold Pattern (Minimal Recreation)

## Pattern summary
This case models bridge transfer authorization that relies on validator signatures and a configurable threshold.

## Vulnerable chain
1. `setThreshold()` allows owner to reduce signing threshold without additional controls.
2. `executeTransfer()` authorizes payouts using signer-count logic against that threshold.
3. If threshold assumptions degrade, high-value transfers can be approved with insufficient security.

## Why detection should succeed
A capable detector should find:
- critical access-control risk on threshold governance,
- critical signature-verification/authorization weakness in transfer execution.

## Expected findings
- `access-control` (critical) in `setThreshold(uint256)`
- `signature-verification` (critical) in `executeTransfer(...)`

## Defensive controls
- immutable minimum threshold floor
- two-step timelocked threshold changes
- quorum + diversity requirements for validator sets
- independent guardian veto for threshold reductions
