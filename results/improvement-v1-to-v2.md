# Improvement Report: v1 to v2

## Headline Scores

| Metric | v1 (baseline) | v2 | Delta | Direction |
|---|---|---|---|---|
| **Composite Score** | **50.32** | **54.55** | **+4.23** | improved |
| Detection Rate | 78.57% (33/42) | 80.95% (34/42) | +2.38pp | improved |
| Precision | 61.11% (33/54) | 75.56% (34/45) | +14.45pp | improved |
| Severity Accuracy | 66.67% (22/33) | 70.59% (24/34) | +3.92pp | improved |
| Brier Score | 0.3108 | 0.2142 | -0.0966 | improved |
| ECE | 0.3131 | 0.1918 | -0.1213 | improved |
| Total Findings | 54 | 45 | -9 | fewer FP |
| False Positives | 21 | 11 | -10 | improved |

## Per-Tier Detection

| Tier | v1 GT Matched | v2 GT Matched | Delta |
|---|---|---|---|
| Tier 1 (Synthetic) | 11/12 (91.67%) | 12/12 (100.00%) | +1 |
| Tier 2 (Real Exploits) | 14/20 (70.00%) | 12/20 (60.00%) | -2 |
| Tier 3 (Public Audits) | 8/10 (80.00%) | 10/10 (100.00%) | +2 |

## New Matches (v2 gained)

| Contract | v1 Status | v2 Status | What Changed |
|---|---|---|---|
| 005-flash-loan-liquidator | 0/1 (class: flash-loan) | 1/1 (class: price-manipulation) | Class taxonomy fix: flash-loan -> price-manipulation |
| 012-beanstalk VULN-002 | 0/1 (class: flash-loan) | 1/1 (class: governance at execute) | Class taxonomy fix: flash-loan -> governance |
| 022-c4-oracle-decimals | 0/1 (class: oracle-manipulation) | 1/1 (class: precision-loss) | Class taxonomy fix: oracle-manipulation -> precision-loss |

## Lost Matches (v2 regressed)

| Contract | v1 Status | v2 Status | What Changed |
|---|---|---|---|
| 014-ronin VULN-002 | Matched (signature-verification) | Missed (agent emitted access-control x2) | Precision guidance caused agent to merge sig-verification into access-control class |
| 020-wormhole VULN-002 | Matched (access-control) | Missed (agent emitted signature-verification x2) | Agent focused on sig-verification class only, missed separate access-control finding |

## Severity Improvements

| Contract | v1 Severity | v2 Severity | GT Severity | Fixed? |
|---|---|---|---|---|
| 002-stale-oracle-vault | high | critical | critical | YES |
| 004-oracle-staleness VULN-001 | high | critical | critical | YES |
| 004-oracle-staleness VULN-002 | medium | high | high | YES |
| 006-governor-timelock | critical | high | high | YES |
| 025-c4-rounding-drift | medium | high | high | YES |

## Severity Regressions

| Contract | v1 Severity | v2 Severity | GT Severity | Issue |
|---|---|---|---|---|
| 008-unchecked-approval VULN-002 | critical | critical | high | Still over-rated |
| 009-proxy-collision | critical | critical | high | Now counted (was matched in v1 too) but wrong sev |
| 010-initializer VULN-001 | critical | critical | high | Still over-rated |
| 010-initializer VULN-002 | medium | medium | medium | OK (was correct in v1 too) |

## Calibration Improvement

| Metric | v1 | v2 | Improvement |
|---|---|---|---|
| Brier Score | 0.3108 | 0.2142 | 31.1% better |
| ECE | 0.3131 | 0.1918 | 38.7% better |
| Avg confidence (all) | 0.916 | ~0.95 (primary) / ~0.85 (secondary) | Better separation |

## What Worked

1. **Class taxonomy guidance** resolved 3 of 9 original FNs (005, 012-VULN-002, 022)
2. **Severity calibration** fixed 5 severity mismatches (002, 004x2, 006, 025)
3. **Precision guidance** reduced findings from 54 to 45 (-9), cutting false positives from 21 to 11 (-10)
4. **Confidence calibration** reduced Brier score by 31% and ECE by 39%

## What Didn't Work

1. **011-euler remains unmatched**: Agent correctly identified price-manipulation but pointed to donate() instead of collateralValue(). The borrow() reentrancy was classified as reentrancy instead of flash-loan (GT class).
2. **Multi-vulnerability detection** didn't fully address missing secondary findings (013, 015, 016 VULN-002s still missing)
3. **Precision guidance backfired slightly**: In trying to reduce over-enumeration, agents dropped distinct vulnerability classes that happened to be GT matches (014 lost sig-verification, 020 lost access-control)
4. **Location targeting** still has issues for 019 (deposit/withdraw vs spot)

## Net Assessment

v2 represents a meaningful improvement over v1:
- **+8.4% composite score** (50.32 -> 54.55)
- **+14.45pp precision** (major driver — fewer false positives)
- **+3.92pp severity accuracy**
- **+2.38pp detection rate** (net +1 GT matched)
- **Significantly better calibration** (Brier -31%, ECE -39%)

The primary remaining ceiling is the Tier 2 real exploit contracts, where complex multi-vulnerability contracts still confuse the class taxonomy (011 euler, 019 harvest location) and where the precision guidance caused the agent to drop distinct secondary findings (014, 020).
