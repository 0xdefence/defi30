#!/usr/bin/env bun
import { readFileSync, writeFileSync } from "node:fs";
import { loadGroundTruth } from "./loader";
import { toMarkdown } from "./reporter";
import { scoreSubmission } from "./scorer";
import type { Submission } from "./types";

function usage() {
  console.log("Usage:");
  console.log("  defi-30 score <submission.json>");
  console.log("  defi-30 validate <submission.json>");
}

const [, , cmd, pathArg, ...flags] = process.argv;
if (!cmd || !pathArg) {
  usage();
  process.exit(1);
}

const strict = flags.includes("--strict");
const submission = JSON.parse(readFileSync(pathArg, "utf8")) as Submission;

const VALID_CLASSES = new Set([
  "reentrancy",
  "oracle-manipulation",
  "flash-loan",
  "access-control",
  "governance",
  "price-manipulation",
  "unchecked-return",
  "delegatecall",
  "initialisation",
  "denial-of-service",
  "precision-loss",
  "signature-verification",
  "storage-collision",
  "front-running",
]);
const VALID_SEVERITIES = new Set(["critical", "high", "medium", "low", "informational"]);

function validateSubmission(): string[] {
  const errs: string[] = [];
  if (!submission.toolName) errs.push("toolName missing");
  if (!submission.toolVersion) errs.push("toolVersion missing");
  if (!submission.timestamp) errs.push("timestamp missing");
  if (!Array.isArray(submission.contracts)) errs.push("contracts must be array");

  const seen = new Set<string>();
  for (const c of submission.contracts || []) {
    if (!c.contractId) errs.push("contractId missing");
    if (seen.has(c.contractId)) errs.push(`duplicate contractId: ${c.contractId}`);
    seen.add(c.contractId);
    for (const f of c.findings || []) {
      if (!VALID_CLASSES.has(String(f.class))) errs.push(`invalid class: ${f.class} @ ${c.contractId}`);
      if (!VALID_SEVERITIES.has(String(f.severity))) errs.push(`invalid severity: ${f.severity} @ ${c.contractId}`);
      if (typeof f.confidence !== "number" || f.confidence < 0 || f.confidence > 1) {
        errs.push(`invalid confidence [0,1]: ${f.confidence} @ ${c.contractId}`);
      }
    }

    const validStatus = new Set(["pass", "fail", "not-run"]);
    if (c.exploitValidation) {
      if (!validStatus.has(String(c.exploitValidation.status))) {
        errs.push(`invalid exploitValidation.status @ ${c.contractId}`);
      }
      const t = c.exploitValidation.timeToFirstValidExploitSeconds;
      if (t !== undefined && (typeof t !== "number" || t < 0)) {
        errs.push(`invalid timeToFirstValidExploitSeconds @ ${c.contractId}`);
      }
    }
    if (c.patchValidation) {
      if (!validStatus.has(String(c.patchValidation.status))) {
        errs.push(`invalid patchValidation.status @ ${c.contractId}`);
      }
    }
  }
  return errs;
}

if (cmd === "validate") {
  const errs = validateSubmission();
  if (errs.length) {
    console.error("Validation errors:\n- " + errs.join("\n- "));
    process.exit(1);
  }
  console.log("Submission format looks valid");
  process.exit(0);
}

if (cmd === "score") {
  const errs = validateSubmission();
  if (strict && errs.length) {
    console.error("Strict mode failed:\n- " + errs.join("\n- "));
    process.exit(1);
  }

  const gt = loadGroundTruth("./contracts");
  const result = scoreSubmission(submission, gt);
  const md = toMarkdown(result);

  console.log(JSON.stringify(result, null, 2));
  writeFileSync("./results/latest-report.md", md);
  writeFileSync("./results/latest-report.json", JSON.stringify(result, null, 2));
  process.exit(0);
}

usage();
process.exit(1);
