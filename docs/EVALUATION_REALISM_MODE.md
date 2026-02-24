# Evaluation Realism Mode (v0.2 draft)

DeFi-30 now supports execution-aware validation fields in submissions:

- `exploitValidation.status`: `pass | fail | not-run`
- `exploitValidation.timeToFirstValidExploitSeconds`
- `patchValidation.status`: `pass | fail | not-run`

## Per-case files

Each realism-enabled case should include:

- `harness/exploit.t.sol` — deterministic exploit success test
- `patched/contract.patched.sol` — mitigated version
- `harness/patch.t.sol` — deterministic test proving exploit path is closed

## Ground truth flags

In `ground-truth.json`:

```json
{
  "exploitValidationRequired": true,
  "patchValidationRequired": true
}
```

## New score outputs

- `exploitSuccessRate`
- `patchSuccessRate`
- `medianTimeToFirstValidExploitSeconds`

## Composite weights (v0.2)

- Detection: 40%
- Precision: 20%
- Severity accuracy: 10%
- Exploit success: 20%
- Patch success: 10%

This mode keeps detect quality central while rewarding tools that can prove exploitability and verify patches.
