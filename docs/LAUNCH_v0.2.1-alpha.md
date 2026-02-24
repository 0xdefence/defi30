# Launch Pack — v0.2.1-alpha

## One-line positioning
DeFi-30 now publishes two explicit tracks — Detect-only and Realism — to avoid mixed-score confusion.

## Release links
- Release: https://github.com/0xdefence/defi30/releases/tag/v0.2.1-alpha
- Repo: https://github.com/0xdefence/defi30
- Realism workflow: https://github.com/0xdefence/defi30/actions/workflows/realism.yml

## Reproducibility block
```bash
git clone https://github.com/0xdefence/defi30.git
cd defi30
bun install
./scripts/run-realism.sh ./results/0xdefend-v1.json
bun run src/cli.ts score ./results/submission-with-realism.json --strict
```

Artifacts:
- `results/realism-validation.json`
- `results/submission-with-realism.json`
- `results/latest-report.json`
- `results/latest-report.md`

## Known limitations
- Tier3 is currently a deterministic seed set derived from public-audit patterns.
- Canonical link mapping is included and expanding in the next drop.

## Launch copy (short post)
DeFi-30 v0.2.1-alpha is live.

We now report **2 separate tracks**:
1) Detect-only
2) Realism (Detect + Exploit + Patch)

No blended scores. Reproducible outputs. DeFi-focused benchmark coverage.

Release: https://github.com/0xdefence/defi30/releases/tag/v0.2.1-alpha

## Launch thread (5 posts)
1. DeFi-30 v0.2.1-alpha is live. We now separate scoring into two tracks: Detect-only and Realism.
2. Why this matters: detection quality and exploit/patch execution are different capabilities. We report both.
3. Realism adds exploit success, patch success, and time-to-first-valid-exploit.
4. Tier2 realism sweep is complete and Tier3 is now seeded through 030 with source mapping docs.
5. Reproduce locally in minutes (commands in README). Release: https://github.com/0xdefence/defi30/releases/tag/v0.2.1-alpha
