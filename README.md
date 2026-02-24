# DeFi-30

**The open benchmark for DeFi smart contract security detection.**

DeFi-30 is a TypeScript-native benchmark for evaluating how well any tool (AI agent, static analyzer, or human-assisted pipeline) detects real DeFi vulnerability patterns.

## Principles
- **The exam is public**.
- **The student is private**.
- Reproducible scoring, transparent methodology, and comparable outputs.

## What ships in this repo
- 30 benchmark contracts (3 tiers of 10)
- Ground truth JSON for each contract
- TypeScript scoring CLI
- Submission schema
- Public leaderboard
- Realism leaderboard (detect + exploit + patch)

> Note: The current Tier3 seed set is derived from public-audit patterns; canonical source links are being expanded in the next drop.

## What does NOT ship in this repo
- 0xDefend proprietary pipeline logic
- LLM prompts/system instructions
- internal orchestration code
- private infrastructure

## Quickstart

```bash
bun install
bun run src/cli.ts score ./results/0xdefend-v1.json --strict
```

Versioning + integrity:
- [BENCHMARK_VERSION.md](./BENCHMARK_VERSION.md)
- [BENCHMARK_CHECKSUMS.json](./BENCHMARK_CHECKSUMS.json)

## Repo layout

```text
defi-30/
├── contracts/
│   ├── tier1/
│   ├── tier2/
│   └── tier3/
├── src/
│   ├── types.ts
│   ├── loader.ts
│   ├── matcher.ts
│   ├── scorer.ts
│   ├── reporter.ts
│   └── cli.ts
├── results/
│   ├── 0xdefend-v1.json
│   └── LEADERBOARD.md
├── METHODOLOGY.md
└── CONTRIBUTING.md
```

## Scoring weights (v0.2 execution-aware)
- Detection Rate: 40%
- Precision: 20%
- Severity Accuracy: 10%
- Exploit Success Rate: 20%
- Patch Success Rate: 10%

Composite = `(Detection * 0.4) + (Precision * 0.2) + (Severity * 0.1) + (Exploit * 0.2) + (Patch * 0.1)`

See [METHODOLOGY.md](./METHODOLOGY.md) and [docs/EVALUATION_REALISM_MODE.md](./docs/EVALUATION_REALISM_MODE.md).

Taxonomy rules: [TAXONOMY.md](./TAXONOMY.md)
