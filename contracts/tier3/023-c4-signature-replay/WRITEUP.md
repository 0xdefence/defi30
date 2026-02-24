# 023 — C4 Signature Replay (Derived)

Derived from audit findings where valid signatures are reusable due to missing nonce/replay guards.

Expected finding:
- `signature-verification` in `execute(address,uint256,bytes32,bytes)`
