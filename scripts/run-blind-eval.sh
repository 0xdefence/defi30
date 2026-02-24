#!/usr/bin/env bash
set -euo pipefail

# Blind eval runner for external agent tools.
#
# Usage:
#   AGENT_CMD='python /path/to/agent.py --contracts ./contracts --out ./results/blind-submission.json' \
#   ./scripts/run-blind-eval.sh
#
# Requirements:
# - AGENT_CMD must output a valid Submission JSON at results/blind-submission.json
# - Agent must not read ground-truth.json during analysis.

OUT_SUBMISSION="./results/blind-submission.json"

if [ -z "${AGENT_CMD:-}" ]; then
  echo "Set AGENT_CMD first." >&2
  echo "Example: AGENT_CMD='my-agent --input ./contracts --output ${OUT_SUBMISSION}' ./scripts/run-blind-eval.sh" >&2
  exit 1
fi

tmpdir="$(mktemp -d)"
cleanup() {
  # restore ground truth files
  if [ -d "$tmpdir/gt" ]; then
    while IFS= read -r p; do
      rel="${p#$tmpdir/gt/}"
      mkdir -p "./contracts/$(dirname "$rel")"
      mv "$p" "./contracts/$rel"
    done < <(find "$tmpdir/gt" -type f -name 'ground-truth.json' | sort)
  fi
  rm -rf "$tmpdir"
}
trap cleanup EXIT

mkdir -p "$tmpdir/gt"

# Move all ground-truth files out of analysis tree
while IFS= read -r p; do
  rel="${p#./contracts/}"
  mkdir -p "$tmpdir/gt/$(dirname "$rel")"
  mv "$p" "$tmpdir/gt/$rel"
done < <(find ./contracts -type f -name 'ground-truth.json' | sort)

echo "[blind-eval] ground truth hidden, running agent..."
bash -lc "$AGENT_CMD"

if [ ! -f "$OUT_SUBMISSION" ]; then
  echo "Missing output submission: $OUT_SUBMISSION" >&2
  exit 1
fi

# restore GT before scoring
cleanup
trap - EXIT

echo "[blind-eval] scoring submission..."
bun run src/cli.ts score "$OUT_SUBMISSION" --strict

echo "[blind-eval] done"
