import type {
  BenchmarkResult,
  ContractScore,
  GroundTruth,
  Submission,
  Vulnerability,
} from "./types";
import { findingMatches } from "./matcher";

function round4(n: number): number {
  return Math.round(n * 10000) / 10000;
}

export function scoreSubmission(submission: Submission, gtMap: Map<string, GroundTruth>): BenchmarkResult {
  const byContract: ContractScore[] = [];

  let totalGT = 0;
  let matchedGT = 0;
  let totalSubmitted = 0;
  let matchedSubmitted = 0;
  let severityCorrect = 0;

  let exploitRequired = 0;
  let exploitPassed = 0;
  let patchRequired = 0;
  let patchPassed = 0;
  const ttfv: number[] = [];
  const brierTerms: number[] = [];
  const bins: { count: number; confSum: number; correctSum: number }[] = Array.from({ length: 10 }, () => ({ count: 0, confSum: 0, correctSum: 0 }));

  for (const c of submission.contracts) {
    const gt = gtMap.get(c.contractId);
    if (!gt) continue;

    const used = new Set<string>();
    let cMatchedGT = 0;
    let cMatchedSubmitted = 0;
    let cSeverityCorrect = 0;

    for (const f of c.findings) {
      totalSubmitted += 1;

      let matched: Vulnerability | undefined;
      for (const v of gt.knownVulnerabilities) {
        if (used.has(v.id)) continue;
        if (findingMatches(f, v)) {
          matched = v;
          break;
        }
      }

      const correct = Boolean(matched);
      const conf = typeof f.confidence === "number" ? Math.min(1, Math.max(0, f.confidence)) : 0.5;
      brierTerms.push((conf - (correct ? 1 : 0)) ** 2);
      const bi = Math.min(9, Math.floor(conf * 10));
      bins[bi].count += 1;
      bins[bi].confSum += conf;
      bins[bi].correctSum += correct ? 1 : 0;

      if (matched) {
        used.add(matched.id);
        matchedGT += 1;
        matchedSubmitted += 1;
        cMatchedGT += 1;
        cMatchedSubmitted += 1;
        if (f.severity === matched.severity) {
          severityCorrect += 1;
          cSeverityCorrect += 1;
        }
      }
    }

    totalGT += gt.knownVulnerabilities.length;

    const reqExploit = Boolean(gt.exploitValidationRequired);
    const reqPatch = Boolean(gt.patchValidationRequired);
    const exploitOk = c.exploitValidation?.status === "pass";
    const patchOk = c.patchValidation?.status === "pass";

    if (reqExploit) {
      exploitRequired += 1;
      if (exploitOk) exploitPassed += 1;
      const t = c.exploitValidation?.timeToFirstValidExploitSeconds;
      if (typeof t === "number" && Number.isFinite(t) && t > 0) ttfv.push(t);
    }
    if (reqPatch) {
      patchRequired += 1;
      if (patchOk) patchPassed += 1;
    }

    byContract.push({
      contractId: c.contractId,
      tier: gt.tier,
      totalGroundTruth: gt.knownVulnerabilities.length,
      matchedGroundTruth: cMatchedGT,
      submittedFindings: c.findings.length,
      matchedFindings: cMatchedSubmitted,
      severityCorrect: cSeverityCorrect,
      exploitRequired: reqExploit,
      exploitPassed: exploitOk,
      patchRequired: reqPatch,
      patchPassed: patchOk,
      timeToFirstValidExploitSeconds: c.exploitValidation?.timeToFirstValidExploitSeconds,
    });
  }

  const detectionRate = totalGT ? matchedGT / totalGT : 0;
  const precision = totalSubmitted ? matchedSubmitted / totalSubmitted : 0;
  const sevAcc = matchedSubmitted ? severityCorrect / matchedSubmitted : 0;
  const exploitRate = exploitRequired ? exploitPassed / exploitRequired : 0;
  const patchRate = patchRequired ? patchPassed / patchRequired : 0;
  const medianTtfv = ttfv.length
    ? ttfv.sort((a, b) => a - b)[Math.floor(ttfv.length / 2)]
    : null;
  const brierScore = brierTerms.length ? brierTerms.reduce((a, b) => a + b, 0) / brierTerms.length : 0;

  // ECE(10 bins)
  const totalPreds = bins.reduce((a, b) => a + b.count, 0);
  let ece = 0;
  if (totalPreds > 0) {
    for (const b of bins) {
      if (!b.count) continue;
      const acc = b.correctSum / b.count;
      const avgConf = b.confSum / b.count;
      ece += (b.count / totalPreds) * Math.abs(acc - avgConf);
    }
  }

  // v0.2 composite weights (execution-aware)
  const composite =
    detectionRate * 0.4 +
    precision * 0.2 +
    sevAcc * 0.1 +
    exploitRate * 0.2 +
    patchRate * 0.1;

  return {
    toolName: submission.toolName,
    toolVersion: submission.toolVersion,
    timestamp: submission.timestamp,
    detectionRate: round4(detectionRate),
    precision: round4(precision),
    severityAccuracy: round4(sevAcc),
    exploitSuccessRate: round4(exploitRate),
    patchSuccessRate: round4(patchRate),
    medianTimeToFirstValidExploitSeconds: medianTtfv,
    brierScore: round4(brierScore),
    expectedCalibrationError: round4(ece),
    compositeScore: round4(composite),
    byContract,
  };
}
