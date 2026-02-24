# DeFi-30 v0.2.0-alpha — Release Notes

## Highlights
- Introduced execution-aware realism mode for benchmark evaluation.
- Expanded Tier2 realism harness quality, including deterministic exploit/patch cases for advanced scenarios.
- Seeded Tier3 with first public-audit-derived cases (`021-023`) including full realism harness structure.
- Added dedicated realism CI workflow and enforcement gate for required validation execution.

## New scoring outputs
- `exploitSuccessRate`
- `patchSuccessRate`
- `medianTimeToFirstValidExploitSeconds`

## Composite scoring (v0.2)
- Detection: 40%
- Precision: 20%
- Severity accuracy: 10%
- Exploit success: 20%
- Patch success: 10%

## Realism infrastructure
- Added `scripts/run-realism.sh` to execute harnesses and auto-populate submission validation fields.
- Added `.github/workflows/realism.yml` to run Foundry + scoring in CI.
- Added CI guard to fail when required exploit/patch validations are `not-run`.

## Dataset evolution
- Tier2 completed across `011-020` with realism-focused hardening.
- Tier3 seeded with:
  - `021-c4-reward-reentrancy`
  - `022-c4-oracle-decimals`
  - `023-c4-signature-replay`

## Integrity + versioning
- Updated `BENCHMARK_CHECKSUMS.json`
- Updated `BENCHMARK_VERSION.md`
- New dataset hash: `b20b2bc3280c48e2e6280b0048c8f7e9f54cac8b856321190a6744affef31278`

## Notes
- Realism metrics currently depend on deterministic harness execution coverage and should be interpreted alongside detect-only metrics.
- Additional Tier3 cases and confidence calibration metrics are planned for the next alpha iteration.
