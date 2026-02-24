# 017 — Parity Delegatecall Pattern (Minimal Recreation)

## Pattern summary
This case reproduces the classic proxy+library failure mode: a wallet proxy forwards arbitrary calls via `delegatecall` into shared library code, and initialization logic remains externally callable.

## Vulnerable chain
1. Proxy `fallback()` forwards all calldata to `lib` via `delegatecall`.
2. Library function `initWallet(address)` can be reached through that fallback path.
3. Because `delegatecall` executes in proxy storage context, attacker overwrites proxy `owner`.
4. Attacker can invoke privileged paths (e.g., `execute`) or destructive functionality (`kill`) once ownership is seized.

## Why detection should succeed
A robust tool should report:
- unsafe delegatecall gateway in proxy fallback,
- re-initialization / initialization-access weakness in library init function.

## Expected findings
- `delegatecall` (critical) in `fallback()`
- `initialisation` (critical) in `initWallet(address)`

## Defensive controls
- avoid broad fallback delegatecall routers for privileged wallets
- lock initialization with one-time guard
- immutable logic addresses + upgrade governance controls
- explicit function-level dispatch and access control
