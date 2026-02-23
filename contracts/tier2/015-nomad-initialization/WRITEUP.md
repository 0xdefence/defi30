# 015 — Nomad Initialization Pattern (Minimal Recreation)

## Pattern summary
This case models an unsafe bridge bootstrapping flow where trust configuration is established by an initializer that is both re-callable and weakly validated.

## Vulnerable chain
1. `initialize()` can be called more than once.
2. `initialize()` accepts `_trustedRoot` directly (including unsafe values like zero root).
3. `process()` trusts `root == trustedRoot` and marks messages as proven.

If initialization can be replayed or set to an unsafe root, message-validation assumptions collapse.

## Why detection should succeed
A strong detector should flag:
- missing one-time initialization guard,
- insecure trust-root configuration in initialization path.

## Expected findings
- `initialisation` (critical) in `initialize(bytes32,address)`
- `access-control` (critical) in `initialize(bytes32,address)` due to unsafe trust bootstrap

## Defensive controls
- strict one-time initializer guard
- explicit validation and non-zero constraints for trusted roots
- immutable bootstrap path or delayed governance-controlled migration
- initialization event monitoring and post-init lock assertions
