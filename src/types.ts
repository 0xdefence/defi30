export type Tier = 1 | 2 | 3;

export type VulnerabilityClass =
  | "reentrancy"
  | "oracle-manipulation"
  | "flash-loan"
  | "access-control"
  | "governance"
  | "price-manipulation"
  | "unchecked-return"
  | "delegatecall"
  | "initialisation"
  | "denial-of-service"
  | "precision-loss"
  | "signature-verification"
  | "storage-collision"
  | "front-running";

export type Severity = "critical" | "high" | "medium" | "low" | "informational";

export interface Vulnerability {
  id: string;
  class: VulnerabilityClass;
  severity: Severity;
  location: string;
  description: string;
  attackVector?: string;
}

export interface GroundTruth {
  contractName: string;
  tier: Tier;
  source?: string;
  totalExpectedFindings: number;
  knownVulnerabilities: Vulnerability[];
}

export interface SubmittedFinding {
  title: string;
  class: VulnerabilityClass;
  severity: Severity;
  location: string;
  description: string;
  confidence: number;
}

export interface ContractSubmission {
  contractId: string;
  findings: SubmittedFinding[];
}

export interface Submission {
  toolName: string;
  toolVersion: string;
  timestamp: string;
  contracts: ContractSubmission[];
}

export interface ContractScore {
  contractId: string;
  tier: Tier;
  totalGroundTruth: number;
  matchedGroundTruth: number;
  submittedFindings: number;
  matchedFindings: number;
  severityCorrect: number;
}

export interface BenchmarkResult {
  toolName: string;
  toolVersion: string;
  timestamp: string;
  detectionRate: number;
  precision: number;
  severityAccuracy: number;
  compositeScore: number;
  byContract: ContractScore[];
}
