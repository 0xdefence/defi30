# DeFi-30 Methodology

## Goal
Measure security detection quality for DeFi-specific vulnerability classes under a standardized, reproducible process.

## Tiers
- **Tier 1 (Synthetic):** controlled contracts with isolated vulnerability patterns.
- **Tier 2 (Real exploit recreations):** minimal reproductions of known incidents.
- **Tier 3 (Raw audit code):** real-world complexity from public audit datasets.

## Matching logic
Each submitted finding is matched against ground truth using:
1. vulnerability class
2. location (exact or fuzzy)
3. optional description overlap (lightweight)

A ground-truth vuln can only be matched once.

## Metrics
### Detection Rate (50%)
`matched_ground_truth / total_ground_truth`

### Precision (30%)
`matched_findings / total_submitted_findings`

### Severity Accuracy (20%)
Among matched findings, percentage with correct severity.

## Composite
`score = detection*0.5 + precision*0.3 + severity*0.2`

## Reporting
Output includes:
- overall metrics + composite
- per-contract breakdown
- optional per-tier breakdown

## Fairness rules
- No benchmark-specific hand-tuned patches hidden from submission metadata.
- Submissions must include tool name/version/timestamp.
- Deterministic output format required.
