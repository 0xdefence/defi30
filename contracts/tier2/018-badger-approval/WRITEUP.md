# 018 — Badger Approval-Drain Pattern (Minimal Recreation)

## Pattern summary
This case models approval-surface abuse seen in wallet/integration compromise incidents: users interact with a seemingly valid flow that grants excessive token approvals to attacker-controlled spenders.

## Vulnerable chain
1. User calls `approveAndPull(spender, amount)`.
2. Contract grants `spender` unlimited allowance (`type(uint256).max`) with no allowlist/trust policy.
3. `spender` can later drain user balance via `transferFrom` using granted approval.
4. Function ignores ERC20 return values, masking failures and increasing integration risk.

## Why detection should succeed
A strong detector should identify both:
- authorization/trust-boundary failure in spender approval logic,
- unchecked ERC20 return-value anti-pattern in token interactions.

## Expected findings
- `access-control` (critical) in `approveAndPull(address,uint256)`
- `unchecked-return` (high) in `approveAndPull(address,uint256)`

## Defensive controls
- never approve arbitrary user-supplied spenders
- require strict spender allowlist/domain separation
- use safe ERC20 wrappers and check return values
- prefer limited, purpose-bound allowances with expiry/revocation
