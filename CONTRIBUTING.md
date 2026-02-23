# Contributing to DeFi-30

## Add a contract case
Each case directory must include:
- `contract.sol`
- `ground-truth.json`
- optional `WRITEUP.md` (required for tier2)

## Ground truth requirements
- clear vulnerability IDs (`VULN-001`, ...)
- one canonical class per finding
- location field must be stable (`functionName` or `Lx-Ly`)

## Submission format
Create a JSON matching `Submission` in `src/types.ts`.

Example:
```bash
bun run src/cli.ts score ./my-submission.json
```

## PR standards
- explain why the case belongs in DeFi-30
- include references for tier2/tier3
- avoid ambiguous or disputed vulnerability labels

## Ethics
Do not include weaponized exploit tooling or private incident data.
This benchmark is defensive and educational.
