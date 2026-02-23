# SCORING_SPEC (v0.1)

## Inputs
- Ground truth JSON per contract
- Submission JSON matching `src/types.ts`

## Matching
A submitted finding matches a ground-truth vuln when:
1. `class` matches exactly
2. `location` matches exact or fuzzy inclusion rule

Each ground-truth vulnerability can be matched at most once.

## Metrics
- Detection Rate = matched ground-truth / total ground-truth
- Precision = matched submitted findings / total submitted findings
- Severity Accuracy = severity-correct matches / matched submitted findings

## Composite
`Composite = Detection*0.5 + Precision*0.3 + Severity*0.2`

## Tie-break
1. Higher detection
2. Higher precision
3. Higher severity accuracy

## Notes
- `confidence` is stored but not weighted in v0.1.
- Future versions may add location-accuracy weighting and confidence calibration.
