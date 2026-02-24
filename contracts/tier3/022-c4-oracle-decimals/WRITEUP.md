# 022 — C4 Oracle Decimals Mismatch (Derived)

Derived from audit findings where 8-decimal oracle values are treated as 18-decimal values.

Expected finding:
- `precision-loss` in `collateralValue(address)`
