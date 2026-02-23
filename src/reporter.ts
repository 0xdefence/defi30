import type { BenchmarkResult } from "./types";

export function toMarkdown(result: BenchmarkResult): string {
  const lines: string[] = [];
  lines.push(`# Benchmark Result: ${result.toolName} ${result.toolVersion}`);
  lines.push("");
  lines.push(`- Timestamp: ${result.timestamp}`);
  lines.push(`- Detection Rate: ${(result.detectionRate * 100).toFixed(2)}%`);
  lines.push(`- Precision: ${(result.precision * 100).toFixed(2)}%`);
  lines.push(`- Severity Accuracy: ${(result.severityAccuracy * 100).toFixed(2)}%`);
  lines.push(`- Composite Score: ${(result.compositeScore * 100).toFixed(2)}`);
  lines.push("");
  lines.push("| Contract | Tier | GT | Matched | Submitted | Precision-Matched | Severity Correct |");
  lines.push("|---|---:|---:|---:|---:|---:|---:|");
  for (const c of result.byContract) {
    lines.push(
      `| ${c.contractId} | ${c.tier} | ${c.totalGroundTruth} | ${c.matchedGroundTruth} | ${c.submittedFindings} | ${c.matchedFindings} | ${c.severityCorrect} |`
    );
  }
  lines.push("");
  return lines.join("\n");
}
