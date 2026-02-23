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

## What does NOT ship in this repo
- 0xDefend proprietary pipeline logic
- LLM prompts/system instructions
- internal orchestration code
- private infrastructure

## Quickstart

```bash
bun install
bun run src/cli.ts score ./results/0xdefend-v1.json
```

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

## Scoring weights
- Detection Rate: 50%
- Precision: 30%
- Severity Accuracy: 20%

Composite = `(Detection * 0.5) + (Precision * 0.3) + (Severity * 0.2)`

See [METHODOLOGY.md](./METHODOLOGY.md) for details.

Taxonomy rules: [TAXONOMY.md](./TAXONOMY.md)
