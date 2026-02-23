# How to Submit to DeFi-30

1. Run your tool against DeFi-30 contracts.
2. Format output as `Submission` JSON (see `src/types.ts` and `SUBMISSION_EXAMPLE.md`).
3. Validate format:

```bash
bun run src/cli.ts validate ./my-submission.json
```

4. Score locally:

```bash
bun run src/cli.ts score ./my-submission.json --strict
```

5. Open a PR with:
- submission JSON in `results/submissions/<tool>-<version>.json`
- generated report markdown
- short run notes (model/tool config)

## Required metadata
- tool name + version
- timestamp
- reproducibility notes (flags/config)
