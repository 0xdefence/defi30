# Blind Evaluation Protocol (Defensible Score)

Use this protocol to produce the *real* pitch-deck number.

## Rule
Agent analysis must run **without access to `ground-truth.json`**.

## Steps
1. Set your agent command to emit `results/blind-submission.json`.
2. Run:

```bash
AGENT_CMD='your-agent --input ./contracts --output ./results/blind-submission.json' \
./scripts/run-blind-eval.sh
```

3. The script will:
- hide all `ground-truth.json`
- run your agent
- restore ground truth
- score submission with DeFi-30 scorer

## Output
- Agent submission: `results/blind-submission.json`
- Scored outputs:
  - `results/latest-report.json`
  - `results/latest-report.md`

## Note
This is the number to use in external claims/pitching.
