# DeFi-30 v0.1.0-alpha — Release Notes

## Highlights
- Initial public benchmark scaffolding shipped (TypeScript-native).
- Tier1 set completed for contracts `001-010`.
- Tier2 implemented cases now include:
  - `011-euler-exchange-rate`
  - `012-beanstalk-governance`
  - `013-cream-callback`
  - `015-nomad-initialization`
  - `016-mango-oracle`
  - `020-wormhole-signature`

## Scoring updates
- Added strict mode validation (`--strict`) in CLI.
- Added taxonomy guidance (`TAXONOMY.md`).
- Added scoring and dataset docs:
  - `SCORING_SPEC.md`
  - `DATASET_CARD.md`
  - `LIMITATIONS.md`
  - `SUBMISSION_EXAMPLE.md`

## Integrity + Versioning
- Added benchmark hash manifest: `BENCHMARK_CHECKSUMS.json`
- Added version marker: `BENCHMARK_VERSION.md`
- Current dataset hash: `5d04bb67891b5fcbfb002c94ce1b53e12c79234d317f3e779cba39d77b01a8d1`

## Known gaps
- Tier2 still contains stubs for some cases.
- Tier3 not yet populated.
- Confidence calibration not yet weighted in scoring.
