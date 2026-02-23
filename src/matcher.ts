import type { SubmittedFinding, Vulnerability } from "./types";

function norm(s: string): string {
  return s.trim().toLowerCase();
}

export function locationMatches(submitted: string, expected: string): boolean {
  const a = norm(submitted);
  const b = norm(expected);
  if (a === b) return true;
  // basic fuzzy rule: function name contained or line-range overlap token
  return a.includes(b) || b.includes(a);
}

export function findingMatches(f: SubmittedFinding, v: Vulnerability): boolean {
  return norm(f.class) === norm(v.class) && locationMatches(f.location, v.location);
}
