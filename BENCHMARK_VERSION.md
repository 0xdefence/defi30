# Benchmark Version

- Current: `v0.2.0-alpha`
- Dataset hash: `b20b2bc3280c48e2e6280b0048c8f7e9f54cac8b856321190a6744affef31278`
- Scope:
  - Tier1 (001-010) with realism harness scaffolding; deterministic exploit/patch implementations for high-signal set.
  - Tier2 (011-020) fully implemented contracts + ground truth, with deterministic realism harness coverage expanded.
  - Tier3 seeded with first public-audit-derived cases (021-023) including exploit/patch harnesses.
- Scoring mode:
  - Detect-only metrics retained
  - Execution-aware metrics enabled: `exploitSuccessRate`, `patchSuccessRate`, `medianTimeToFirstValidExploitSeconds`

Use `BENCHMARK_CHECKSUMS.json` to verify file-level integrity.
