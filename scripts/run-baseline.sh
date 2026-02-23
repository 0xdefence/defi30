#!/usr/bin/env bash
set -euo pipefail

SUBMISSION="${1:-./results/0xdefend-v1.json}"

echo "Scoring submission: $SUBMISSION"
bun run src/cli.ts score "$SUBMISSION"
echo "Output: ./results/latest-report.json and ./results/latest-report.md"
