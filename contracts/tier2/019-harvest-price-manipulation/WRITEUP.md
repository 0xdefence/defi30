# 019 — Harvest Price Manipulation Pattern (Minimal Recreation)

## Pattern summary
This case models vault share accounting tied directly to AMM spot price.

## Vulnerable chain
1. `spot()` trusts raw AMM spot from a single venue.
2. `deposit()` mints shares using that spot price.
3. `withdraw()` redeems assets using that same manipulable spot path.
4. Temporary price distortion can create favorable mint/redeem imbalance.

## Why detection should succeed
A strong detector should identify:
- oracle/price-source weakness (`spot()`),
- accounting exploitation path in share minting (`deposit()`) and redemption coupling.

## Expected findings
- `oracle-manipulation` (critical) in `spot()`
- `price-manipulation` (critical) in `deposit(uint256)`

## Defensive controls
- TWAP/medianized pricing source
- mint/redeem guards during abnormal volatility
- max slippage/deviation checks for accounting-critical prices
- delayed settlement windows for large operations
