import type { SubmittedFinding, Vulnerability } from "./types";

function norm(s: string): string {
  return s.trim().toLowerCase();
}

function parseRange(x: string): [number, number] | null {
  const m = x.match(/^l(\d+)\s*-\s*l?(\d+)$/i);
  if (!m) return null;
  const a = Number(m[1]);
  const b = Number(m[2]);
  if (!Number.isFinite(a) || !Number.isFinite(b)) return null;
  return a <= b ? [a, b] : [b, a];
}

function rangesOverlap(r1: [number, number], r2: [number, number]): boolean {
  return r1[0] <= r2[1] && r2[0] <= r1[1];
}

export function locationMatches(submitted: string, expected: string): boolean {
  const a = norm(submitted);
  const b = norm(expected);
  if (a === b) return true;

  const ra = parseRange(a);
  const rb = parseRange(b);
  if (ra && rb) return rangesOverlap(ra, rb);

  // function-name / token containment fallback
  return a.includes(b) || b.includes(a);
}

export function findingMatches(f: SubmittedFinding, v: Vulnerability): boolean {
  return norm(f.class) === norm(v.class) && locationMatches(f.location, v.location);
}
