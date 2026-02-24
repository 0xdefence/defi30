import type { BenchmarkResult } from "./types";

export function toMarkdown(result: BenchmarkResult): string {
  const lines: string[] = [];
  lines.push(`# Benchmark Result: ${result.toolName} ${result.toolVersion}`);
  lines.push("");
  lines.push(`- Timestamp: ${result.timestamp}`);
  lines.push(`- Detection Rate: ${(result.detectionRate * 100).toFixed(2)}%`);
  lines.push(`- Precision: ${(result.precision * 100).toFixed(2)}%`);
  lines.push(`- Severity Accuracy: ${(result.severityAccuracy * 100).toFixed(2)}%`);
  lines.push(`- Exploit Success Rate: ${(result.exploitSuccessRate * 100).toFixed(2)}%`);
  lines.push(`- Patch Success Rate: ${(result.patchSuccessRate * 100).toFixed(2)}%`);
  lines.push(`- Median Time to First Valid Exploit: ${result.medianTimeToFirstValidExploitSeconds ?? "n/a"}s`);
  lines.push(`- Brier Score (confidence): ${result.brierScore.toFixed(4)}`);
  lines.push(`- Expected Calibration Error (ECE@10): ${result.expectedCalibrationError.toFixed(4)}`);
  lines.push(`- Composite Score: ${(result.compositeScore * 100).toFixed(2)}`);
  lines.push("");
  lines.push("| Contract | Tier | GT | Matched | Submitted | Precision-Matched | Severity Correct | Exploit | Patch | TTFV(s) |");
  lines.push("|---|---:|---:|---:|---:|---:|---:|---|---|---:|");
  for (const c of result.byContract) {
    lines.push(
      `| ${c.contractId} | ${c.tier} | ${c.totalGroundTruth} | ${c.matchedGroundTruth} | ${c.submittedFindings} | ${c.matchedFindings} | ${c.severityCorrect} | ${c.exploitRequired ? (c.exploitPassed ? "pass" : "fail") : "n/a"} | ${c.patchRequired ? (c.patchPassed ? "pass" : "fail") : "n/a"} | ${c.timeToFirstValidExploitSeconds ?? "-"} |`
    );
  }
  lines.push("");
  return lines.join("\n");
}
