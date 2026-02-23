# 013 — Cream Callback Reentrancy Pattern (Minimal Recreation)

## Pattern summary
This case models a borrow flow where an external callback and token transfer occur before debt state is finalized.

## Vulnerable chain
1. Borrow eligibility check passes.
2. Protocol calls external callback (`tokensReceived`) before debt update.
3. Reentrant path can invoke borrow again under stale debt state.
4. Debt is updated too late.

## Why detection should succeed
A strong detector should identify:
- reentrancy through callback ordering,
- missing guard around externally-controlled callback path.

## Expected findings
- `reentrancy` (critical)
- `access-control`/guarding weakness (high)

## Defensive controls
- checks-effects-interactions ordering
- reentrancy guard around borrow path
- minimize externally-controlled hooks in critical accounting flow
