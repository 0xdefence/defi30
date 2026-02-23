# 011 — Euler Exchange Rate Manipulation (Minimal Recreation)

## Pattern summary
This case models an exchange-rate based lending market where collateral value is derived from:

`shares[user] * exchangeRate()`

The exchange rate itself is immediately affected by `donate()` and consumed without smoothing or manipulation resistance.

## Why it is vulnerable
- `donate()` increases `totalAssets` directly.
- `exchangeRate()` jumps immediately.
- `borrow()` trusts this elevated rate in the same execution window.

An attacker can use temporary liquidity (including flash liquidity) to push valuation, pass LTV checks, borrow, then unwind external price pressure.

## Detection expectations
A strong detector should flag:
1. **Price-manipulation risk** in valuation path (`collateralValue`).
2. **Flash-loan amplified borrow bypass** in borrow gate logic (`borrow`).

## Defensive controls
- time-weighted exchange-rate window
- borrow throttles after abnormal exchange-rate movement
- donation exclusion from collateral valuation for N blocks
- multi-source sanity bounds
