import type { SubmittedFinding, Vulnerability } from "./types";

function norm(s: string): string {
  return s.trim().toLowerCase();
}

/**
 * Strip Solidity-style parameter types from function signatures.
 * e.g. "withdraw(uint256)" → "withdraw()"
 *      "execute(address,uint256,bytes)" → "execute()"
 *      "ContractName.foo(uint256)" → "contractname.foo()"
 * Already-bare names like "withdraw()" or "withdraw" pass through unchanged.
 */
function stripParams(s: string): string {
  return s.replace(/\([^)]*\)/g, "()");
}

/**
 * Extract just the bare function name from a location string.
 * e.g. "ContractName.withdraw(uint256)" → "withdraw"
 *      "withdraw()" → "withdraw"
 *      "withdraw" → "withdraw"
 */
function bareName(s: string): string {
  // Remove everything from '(' onward
  const noParams = s.replace(/\(.*$/, "");
  // Take last segment after '.'
  const parts = noParams.split(".");
  return parts[parts.length - 1];
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

  // Normalize param types: "withdraw(uint256)" → "withdraw()"
  const aStripped = stripParams(a);
  const bStripped = stripParams(b);
  if (aStripped === bStripped) return true;

  // Containment after stripping params (handles ContractName.foo() vs foo())
  if (aStripped.includes(bStripped) || bStripped.includes(aStripped)) return true;

  // Bare function name match: "ContractName.withdraw(uint256)" vs "withdraw()"
  if (bareName(a) === bareName(b) && bareName(a).length > 0) return true;

  // Original containment fallback
  return a.includes(b) || b.includes(a);
}

export function findingMatches(f: SubmittedFinding, v: Vulnerability): boolean {
  return norm(f.class) === norm(v.class) && locationMatches(f.location, v.location);
}
