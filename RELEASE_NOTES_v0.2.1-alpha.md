# DeFi-30 v0.2.1-alpha — Release Notes

## Highlights
- Completed Tier2 realism rigor sweep across `011-020`.
- Expanded Tier3 seed set from `021-023` to `021-030`.
- Added canonical Tier3 source mapping doc (`docs/TIER3_SOURCES.md`).
- Hardened public messaging for strict detect-only vs realism track separation.
- Added confidence calibration reporting in scoring output.

## Added metrics
- `brierScore`
- `expectedCalibrationError` (ECE@10)

## Dataset + integrity
- Updated benchmark manifest to include new Tier3 cases and latest ground truth.
- Dataset hash: `c2ccce5090512fa166c666a483090ad6c52856259a8bf3f05482e1ef14016790`

## Notes
- Tier3 cases remain deterministic benchmark abstractions derived from public-audit patterns.
- Canonical source linkage is documented and will continue expanding in future drops.
