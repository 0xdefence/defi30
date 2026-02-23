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

const [, , cmd, pathArg] = process.argv;
if (!cmd || !pathArg) {
  usage();
  process.exit(1);
}

const submission = JSON.parse(readFileSync(pathArg, "utf8")) as Submission;

if (cmd === "validate") {
  if (!submission.toolName || !submission.contracts) {
    console.error("Invalid submission format");
    process.exit(1);
  }
  console.log("Submission format looks valid");
  process.exit(0);
}

if (cmd === "score") {
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
