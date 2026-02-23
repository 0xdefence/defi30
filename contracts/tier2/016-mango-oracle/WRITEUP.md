# 016 — Mango Oracle Manipulation Pattern (Minimal Recreation)

## Pattern summary
This case recreates a common DeFi failure: protocol borrows are guarded by collateral valuation derived from a manipulable AMM spot price.

## Vulnerable chain
1. `spotPrice()` reads reserve ratio from a single AMM pair.
2. Attacker temporarily distorts reserves (thin liquidity / flash capital).
3. `collateralValue()` is inflated.
4. `borrow()` accepts inflated collateral and releases funds.

## Why detection should succeed
A strong detector should identify both:
- oracle design issue in `spotPrice()` (no TWAP/deviation guard), and
- lending risk issue in `borrow()` (trusting spot-derived collateral directly).

## Expected findings
- `oracle-manipulation` in `spotPrice()`
- `price-manipulation` in `borrow(uint256)`

## Defensive controls
- TWAP or robust median oracle path
- min-liquidity/depth constraints
- confidence-weighted LTV and borrow caps
- circuit breaker on abnormal price moves
