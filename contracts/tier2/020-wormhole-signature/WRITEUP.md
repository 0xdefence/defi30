# 020 — Wormhole Signature Verification Pattern (Minimal Recreation)

## Pattern summary
This case models a bridge-like execution endpoint that should only execute authorized signed payloads.

## Vulnerable chain
1. `recover()` returns `address(0)` for malformed signatures instead of reverting.
2. `execute()` incorrectly allows `signer == address(0)`.
3. Digest construction lacks strong domain separation (no chain/contract binding).
4. Authorization uses single signer semantics instead of robust guardian thresholding.

## Why detection should succeed
A capable detector should flag:
- signature verification bypass logic,
- weak authorization model for high-impact execution path.

## Expected findings
- `signature-verification` (critical)
- `access-control` (critical)

## Defensive controls
- strict signature parser + reject on malformed signatures
- mandatory non-zero signer + threshold signature validation
- domain-separated digest (chainId, contract address, typed data)
- replay protection keyed by full signed message envelope
