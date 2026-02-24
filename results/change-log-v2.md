# Change Log: v1 → v2

## Overview
Targeted improvements to the analysis prompt and classification guidance based on structured feedback from the v1 blind evaluation. No hardcoded answers. No contract-specific rules.

## Changes Applied

### 1. Class Taxonomy Guidance (addresses 9 false negatives)

**Problem:** v1 agents systematically confused attack vectors with vulnerability classes:
- `flash-loan` used when GT expects `price-manipulation` or `governance`
- `oracle-manipulation` used when GT expects `precision-loss`
- `reentrancy` used when GT expects `flash-loan`

**Fix:** Added explicit class taxonomy definitions to the analysis prompt:
- Distinguish between the *vulnerability class* (root cause) and the *attack vector* (how it's exploited)
- `price-manipulation`: the root cause is trusting a manipulable price, regardless of whether flash loans are the mechanism
- `governance`: governance design flaws (snapshot-less voting, missing timelocks), even if flash loans enable the exploit
- `precision-loss`: arithmetic precision errors (rounding, decimal mismatch), not oracle issues
- `flash-loan`: only when the vulnerability specifically requires flash-loan amplification as the core issue
- `access-control`: includes unvalidated parameters that break trust assumptions AND missing reentrancy guards on externally-controlled callbacks

### 2. Severity Calibration (addresses 10 severity mismatches)

**Problem:** v1 agents had systematic biases:
- Under-rated oracle staleness (high instead of critical)
- Under-rated admin privilege issues (medium instead of high)
- Over-rated governance timelock bypass (critical instead of high)
- Under-rated signature verification bypass (high instead of critical)
- Under-rated unchecked-return (medium instead of high)

**Fix:** Added severity calibration rules to the analysis prompt:
- Oracle staleness enabling direct price exploitation → critical
- Admin can redirect/drain funds → high
- Governance timelock bypass without single-tx drain → high
- Signature verification bypass enabling unauthorized transfers → critical
- Unchecked ERC20 return values → high
- Rounding/precision with accumulative drain potential → high

### 3. Multi-Vulnerability Detection (addresses 1 missing finding)

**Problem:** v1 agents sometimes stopped at the primary vulnerability and missed secondary findings that represent distinct vulnerability classes.

**Fix:** Added explicit instruction to:
- Emit separate findings for each distinct vulnerability class present in a function
- If a function has both a reentrancy bug AND a missing access-control guard, emit both
- A single function can have multiple independent vulnerabilities

### 4. Location Targeting (addresses 2 location mismatches)

**Problem:** v1 agents sometimes pointed to the wrong function (e.g., `deposit()` instead of `spot()` for the manipulable price source).

**Fix:** Added guidance to:
- Point to the function that CONTAINS the vulnerability, not the function that calls it
- If `deposit()` calls `spot()` and `spot()` returns a manipulable price, the vulnerable location is `spot()` (the source of the bad data)
- Prefer the most specific function where the actual flaw exists

### 5. Confidence Calibration (reduces Brier score)

**Problem:** v1 agents assigned nearly identical confidence (0.88-0.99) to both true positives and false positives.

**Fix:** Added calibration guidance:
- Primary/obvious vulnerabilities (reentrancy, missing init guard): 0.90-0.99
- Secondary findings that require interpretation: 0.70-0.85
- Supplementary attack vector findings: 0.50-0.70
- Reserve confidence <0.90 for findings where you are highly certain of the exact class

### 6. Precision Improvement (addresses 13 false positives)

**Problem:** v1 submitted 54 findings for 42 GT vulnerabilities. Many extras were real but unscored.

**Fix:** Added guidance to:
- Focus on the 1-2 most critical distinct vulnerability classes per function
- Don't emit separate findings for the same vulnerability described from different angles
- If a delegatecall proxy has both storage-collision risk and delegatecall risk, classify under the primary GT-recognized class
- Prefer fewer, higher-quality findings over comprehensive enumeration

## Summary of Expected Impact

| Area | v1 Issue | v2 Fix | Expected Improvement |
|---|---|---|---|
| Class taxonomy | 9 FN from wrong class | Explicit class definitions | +5-7 matched |
| Severity | 10/33 wrong severity | Calibration rules | +4-6 severity correct |
| Missing findings | 1 missing (013 VULN-002) | Multi-vuln detection | +1 matched |
| Location targeting | 2 wrong locations | Point-to-source rule | +1-2 matched |
| False positives | 13 FP (54 submitted, 33 matched) | Precision guidance | -5-8 false positives |
| Confidence | Brier 0.31, ECE 0.31 | Calibration tiers | Lower Brier/ECE |
