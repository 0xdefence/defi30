import { readdirSync, readFileSync, statSync } from "node:fs";
import { join } from "node:path";
import type { GroundTruth } from "./types";

export function loadGroundTruth(root = "./contracts"): Map<string, GroundTruth> {
  const out = new Map<string, GroundTruth>();
  const tiers = ["tier1", "tier2", "tier3"];

  for (const tier of tiers) {
    const tierDir = join(root, tier);
    let dirs: string[] = [];
    try {
      dirs = readdirSync(tierDir);
    } catch {
      continue;
    }

    for (const d of dirs) {
      const full = join(tierDir, d);
      if (!statSync(full).isDirectory()) continue;
      const gtPath = join(full, "ground-truth.json");
      try {
        const parsed = JSON.parse(readFileSync(gtPath, "utf8")) as GroundTruth;
        out.set(d, parsed);
      } catch {
        // skip incomplete case folders in scaffold stage
      }
    }
  }
  return out;
}
