# DeFi-30 Vulnerability Taxonomy (v0.1)

This file defines class boundaries so contributors label findings consistently.

## Core distinction: `oracle-manipulation` vs `price-manipulation`

### `oracle-manipulation`
Use when the security failure is primarily in **oracle ingestion/consumption**:
- stale price acceptance
- weak aggregation (latest/spot-only, no robust median/TWAP)
- missing source-quality/deviation guards
- feed replacement/adapter misuse

Examples:
- stale oracle check bypass
- thin-venue print accepted by oracle adapter without guardrails

### `price-manipulation`
Use when exploitability mainly comes from **directly moving market price inputs** used by protocol logic:
- AMM spot manipulation
- low-liquidity orderbook repricing
- flash-loan assisted temporary repricing

Examples:
- liquidation triggered from manipulable spot
- collateral/debt valuation from single manipulable market

## Other class notes
- `flash-loan` = primary exploit primitive is the loan itself (capital amplifier), not just a market movement side effect.
- `governance` = proposal/timelock/quorum/delegation control failures.
- `delegatecall` vs `storage-collision`:
  - use `delegatecall` when unsafe execution context is core issue,
  - use `storage-collision` when slot overlap corruption is primary issue.

## Labeling rules
1. One canonical class per ground-truth finding.
2. If multiple vectors exist, use `attackVector` for secondary mechanism.
3. Prefer stable class semantics over incident-specific naming.
