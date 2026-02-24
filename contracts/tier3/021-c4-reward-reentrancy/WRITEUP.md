# 021 — C4 Reward Reentrancy (Derived)

Derived from common Code4rena reward-claim anti-patterns where user payout occurs before balance update.

Expected finding:
- `reentrancy` in `claim()`
