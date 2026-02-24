# Benchmark Version

- Current: `v0.2.1-alpha`
- Dataset hash: `c2ccce5090512fa166c666a483090ad6c52856259a8bf3f05482e1ef14016790`
- Scope:
  - Tier1 (001-010) with realism harness scaffolding and deterministic exploit/patch implementations for high-signal set.
  - Tier2 (011-020) with deterministic realism harness quality sweep completed across all cases.
  - Tier3 seeded to `021-030` with public-audit-derived patterns and realism harnesses.
- Scoring mode:
  - Detect-only + execution-aware metrics
  - Confidence calibration metrics included (`brierScore`, `expectedCalibrationError`)

Use `BENCHMARK_CHECKSUMS.json` to verify file-level integrity.
