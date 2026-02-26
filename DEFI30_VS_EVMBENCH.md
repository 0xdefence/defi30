# DeFi-30 vs EVMBench: Benchmark Comparison

A side-by-side comparison of the two smart-contract security benchmarks used to evaluate 0xDefend.

---

## Overview

| | DeFi-30 | EVMBench |
|---|---------|----------|
| **Purpose** | DeFi-focused vulnerability pattern evaluation with reproducible, deterministic scoring | Broad smart-contract agent evaluation harness with multi-mode grading |
| **Contracts** | 30 contracts (3 tiers of 10) | 40 real-world C4 contest audits |
| **Total vulnerabilities** | 42 | 120 |
| **Avg vulns per unit** | 1.4 | 3 (up to 14) |
| **Time span** | Synthetic + 2020-2025 exploits + C4 findings | 2023-2026 C4 contests |
| **Source material** | Synthetic recreations + simplified real exploits + public audit patterns | Direct C4 contest repos (unmodified) |
| **Language** | TypeScript (Bun) | Python (uv) + Rust (ploit) |

---

## Contract Coverage

### DeFi-30: Three Tiers

**Tier 1 — Synthetic (10 contracts, 12 vulns)**
Controlled, single-vulnerability contracts testing each class in isolation.
Includes one negative control (003-clean-vault, 0 vulns).

**Tier 2 — Real Exploits (10 contracts, 20 vulns)**
Simplified recreations of real DeFi incidents (Euler, Beanstalk, Cream, Ronin, Nomad, Mango, Parity, Badger, Harvest, Wormhole).
Each contract has 2 vulnerabilities on average.

**Tier 3 — Public Audits (10 contracts, 10 vulns)**
Patterns derived from Code4rena findings (reentrancy, oracle, signature, init, rounding, DoS, access control).
One vulnerability per contract.

### EVMBench: 40 Real Audits

Unmodified contest codebases from Code4rena spanning 2023-2026:
- PoolTogether, NextGen, EthereumCreditGuild (2023)
- Curves, Canto, Noya, Taiko, Basin, Phi, Wildcat, etc. (2024)
- Liquid-Ron, Virtuals, Blackhole, Panoptic (2025)
- Tempo suite (FeeAMM, MPP-Streams, Stablecoin-DEX) (2026)

Multi-file, multi-contract codebases with full build environments.

---

## Taxonomy & Ground Truth

| Dimension | DeFi-30 | EVMBench |
|-----------|---------|----------|
| **Taxonomy** | 14 formal classes (reentrancy, oracle-manipulation, price-manipulation, flash-loan, access-control, governance, delegatecall, initialisation, denial-of-service, precision-loss, signature-verification, storage-collision, front-running, unchecked-return) | No fixed taxonomy; free-form finding descriptions |
| **Ground truth format** | JSON per contract: class, severity, location, attackVector | Markdown descriptions in `findings/` directories |
| **Labeling rules** | One canonical class per finding, `attackVector` for secondary mechanism, formal disambiguation in [TAXONOMY.md](./TAXONOMY.md) | Findings written as-is from C4 judging |

### DeFi-30 Ground Truth Example
```json
{
  "contractName": "ReentrancyVault",
  "tier": 1,
  "totalExpectedFindings": 1,
  "knownVulnerabilities": [{
    "id": "VULN-001",
    "class": "reentrancy",
    "severity": "critical",
    "location": "withdraw()",
    "description": "State update occurs after external call",
    "attackVector": "callback"
  }]
}
```

### EVMBench Ground Truth Example
```yaml
vulnerabilities:
  - id: "H-02"
    title: "A malicious user can steal other user's deposits from Vault.sol"
    test: test_Exploit_H02_WithdrawBurnTruncation
    award: 2181.44
    exploit_task: true
```

---

## Matching & Scoring

### DeFi-30: Deterministic Matching

**Match criteria** (all must hold):
1. Vulnerability class matches exactly (case-insensitive)
2. Location matches via: exact match, line-range overlap, parameter-stripped match, bare function name, or containment

**Composite score formula** (v0.2):
```
Composite = (Detection x 0.4) + (Precision x 0.2) + (Severity x 0.1) + (Exploit x 0.2) + (Patch x 0.1)
```

| Metric | Weight | Definition |
|--------|--------|------------|
| Detection Rate | 40% | Ground-truth vulns matched / total ground-truth |
| Precision | 20% | Matched findings / total submitted findings |
| Severity Accuracy | 10% | Correct severity among matched findings |
| Exploit Success | 20% | Foundry exploit tests passed |
| Patch Success | 10% | Foundry patch tests passed |

Additional diagnostics: Brier score (confidence calibration), ECE@10 (expected calibration error).

### EVMBench: LLM Judge

**Match criteria** (evaluated by Claude Opus 4.6):
- Same underlying security flaw/mechanism
- Same code path/function
- Same fix would resolve both
- An attack that works for one would work for the other

**Scoring**:
- Count-weighted detection rate (vulns found / total vulns)
- Award-weighted detection rate ($ captured / $ available)

No precision, severity, or composite metrics.

### Tradeoff

DeFi-30's deterministic matching is fully reproducible but requires a formal taxonomy and structured ground truth. EVMBench's LLM judge handles free-form reports naturally but introduces non-determinism — running the same submission twice may yield different scores.

---

## Evaluation Modes

| Mode | DeFi-30 | EVMBench |
|------|---------|----------|
| **Detect** | Core focus; class + location + severity matching | Primary mode; LLM judge grading |
| **Exploit** | Foundry harness (`exploit.t.sol`), 20% of composite | Ploit (Rust/Anvil transaction replay), separate mode |
| **Patch** | Foundry harness (`patch.t.sol`), 10% of composite | Test suite validation of unified diffs, separate mode |
| **Track separation** | Detect-only + Realism (combined) in one composite | Three independent modes |

DeFi-30 combines all modes into a single composite. EVMBench evaluates each mode independently with separate task splits (40 detect, 24 patch, 10 exploit).

---

## 0xDefend Performance

### DeFi-30 (v6-swarm, blind, fully autonomous)

| Metric | Score |
|--------|-------|
| **Composite** | **42.31** |
| Detection Rate | 78.57% (33/42) |
| Precision | 22.60% (33/146) |
| Severity Accuracy | 63.64% (21/33) |
| Exploit Success | 0.00% |
| Patch Success | 0.00% |
| Brier Score | 0.5820 |
| ECE@10 | 0.6557 |

**Per-tier detection**: Tier 1 (synthetic): 100% | Tier 2 (real exploits): 55% | Tier 3 (public audits): 100%

### EVMBench (10-audit sample, detect mode)

| Metric | Score |
|--------|-------|
| Detection Rate | 46.2% (12/26) |
| Award-Weighted Rate | 14.4% ($2,349/$16,314) |
| Perfect Audits | 4/10 (40%) |
| Zero-Detect Audits | 2/10 (20%) |
| Estimated Precision | ~25-30% |

**Published baselines**: Claude Opus 4.6 = 45.6%, GPT-5.3-Codex = 41.0%, GPT-5 = 22.0%.
0xDefend's 46.2% matches the published Claude baseline within sampling error.

### Side-by-Side

| | DeFi-30 | EVMBench |
|---|---------|----------|
| **Detection** | 78.6% | 46.2% |
| **Precision** | 22.6% | ~25-30% |
| **Composite** | 42.31 | N/A |
| **Award-weighted** | N/A | 14.4% |

The 32pp detection gap (78.6% vs 46.2%) reflects the difficulty difference: DeFi-30's single-contract, taxonomy-aligned format is easier to classify than EVMBench's multi-file, real-world codebases.

---

## What Each Benchmark Reveals

### DeFi-30 uniquely measures

- **Per-class detection capability** — which of the 14 vulnerability classes the tool can/can't find
- **Precision** — false positive rate (22.6% means ~4 false positives per true positive)
- **Severity calibration** — whether the tool rates severity correctly (63.6%)
- **Confidence calibration** — Brier + ECE show the tool's confidence scores are poorly calibrated
- **Execution capability** — can the tool produce working exploits and patches (currently 0%)

### EVMBench uniquely measures

- **Real-world audit performance** — against unmodified C4 contest code
- **Economic impact** — award-weighted scoring shows which missed vulns matter most
- **Cross-contract reasoning** — multi-file, multi-dependency codebases
- **Domain-specific detection** — rebasing tokens, signature replay, gas DoS
- **Multi-agent comparison** — standardized results across Claude, GPT, Gemini, Codex

---

## Vulnerability Category Analysis

### Strong categories (both benchmarks agree)

| Category | DeFi-30 | EVMBench | Notes |
|----------|---------|----------|-------|
| Access control | High | 88% (7/8) | Surface-level, single-function analysis |
| Reentrancy (basic CEI) | High | 100% (2/2) | Standard pattern recognition |
| Arithmetic bugs | High | 100% (3/3) | Copy-paste, truncation |

### Weak categories (EVMBench reveals gaps DeFi-30 doesn't test)

| Category | EVMBench Rate | Why Missed |
|----------|---------------|------------|
| Cross-chain signature replay | 0% (0/2) | Requires tracing signed payload contents across contracts |
| Domain-specific tokens | 0% (0/1) | Rebasing (AMPL gonsPerFragment), fee-on-transfer |
| Gas-based DoS | 0% (0/1) | Unbounded iteration in EnumerableMap |
| Multi-step interaction attacks | 0% (0/3) | Honeypots, forced extension + claim, post-deploy governance |
| Complex reentrancy | 0% (0/1) | Reentrancy through refund paths during creation |

DeFi-30 tests individual vulnerability patterns well. EVMBench reveals that combining multiple patterns in a real codebase dramatically increases difficulty.

---

## Design Philosophy

### DeFi-30

- **The exam is public, the student is private.** Ground truth is transparent; tool internals are not.
- Reproducible, deterministic scoring anyone can verify.
- Community submission format with public leaderboard.
- Dual-track (detect-only + realism) but no cross-track comparison.
- Formal taxonomy enforces consistent labeling.

### EVMBench

- Research harness for comparing AI agent architectures.
- Docker-containerized per-audit isolation.
- Supports multiple agents (Claude, GPT, Gemini, Codex) with standardized configs.
- Award-weighted scoring reflects real economic stakes.
- LLM judge allows free-form reports without forcing a taxonomy.

---

## Summary

DeFi-30 and EVMBench are **complementary**:

- **DeFi-30** answers: "How well does a tool classify known DeFi vulnerability patterns?" — taxonomy accuracy, precision, severity calibration, execution capability.
- **EVMBench** answers: "How well would a tool perform in a real C4 contest?" — detection rate on unmodified code, dollar impact of misses, cross-contract reasoning.

Running both gives a more complete picture. The 78.6% vs 46.2% detection gap quantifies the difficulty jump from curated single-contract patterns to real-world multi-file audits — the primary area where current AI audit tools need to improve.
