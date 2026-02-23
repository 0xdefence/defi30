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

    byContract.push({
      contractId: c.contractId,
      tier: gt.tier,
      totalGroundTruth: gt.knownVulnerabilities.length,
      matchedGroundTruth: cMatchedGT,
      submittedFindings: c.findings.length,
      matchedFindings: cMatchedSubmitted,
      severityCorrect: cSeverityCorrect,
    });
  }

  const detectionRate = totalGT ? matchedGT / totalGT : 0;
  const precision = totalSubmitted ? matchedSubmitted / totalSubmitted : 0;
  const sevAcc = matchedSubmitted ? severityCorrect / matchedSubmitted : 0;
  const composite = detectionRate * 0.5 + precision * 0.3 + sevAcc * 0.2;

  return {
    toolName: submission.toolName,
    toolVersion: submission.toolVersion,
    timestamp: submission.timestamp,
    detectionRate: round4(detectionRate),
    precision: round4(precision),
    severityAccuracy: round4(sevAcc),
    compositeScore: round4(composite),
    byContract,
  };
}
