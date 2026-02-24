#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   scripts/run-realism.sh [base-submission.json]
#
# Produces:
# - results/realism-validation.json
# - results/submission-with-realism.json

BASE_SUBMISSION="${1:-./results/0xdefend-v1.json}"
OUT_VALIDATION="./results/realism-validation.json"
OUT_SUBMISSION="./results/submission-with-realism.json"

if [ ! -f "$BASE_SUBMISSION" ]; then
  echo "Base submission not found: $BASE_SUBMISSION" >&2
  exit 1
fi

HAS_FORGE=0
if command -v forge >/dev/null 2>&1; then
  HAS_FORGE=1
fi

BASE_SUBMISSION="$BASE_SUBMISSION" OUT_VALIDATION="$OUT_VALIDATION" OUT_SUBMISSION="$OUT_SUBMISSION" HAS_FORGE="$HAS_FORGE" python3 - <<'PY'
import json, os, subprocess, time
from pathlib import Path

base_submission = Path(os.environ.get('BASE_SUBMISSION', './results/0xdefend-v1.json'))
out_validation = Path(os.environ.get('OUT_VALIDATION', './results/realism-validation.json'))
out_submission = Path(os.environ.get('OUT_SUBMISSION', './results/submission-with-realism.json'))
repo = Path('.')

sub = json.loads(base_submission.read_text())
contracts_map = {c['contractId']: c for c in sub.get('contracts', [])}

# Ensure every known tier1/tier2 contract exists in submission with findings array.
for tier in ['tier1', 'tier2']:
    tdir = repo / 'contracts' / tier
    if not tdir.exists():
        continue
    for d in sorted([x for x in tdir.iterdir() if x.is_dir()]):
        contracts_map.setdefault(d.name, {'contractId': d.name, 'findings': []})

has_forge = os.environ.get('HAS_FORGE', '0') == '1'

results = []

def run_forge(test_path: Path):
    t0 = time.time()
    cmd = ['forge', 'test', '-q', '--match-path', str(test_path)]
    p = subprocess.run(cmd, cwd=repo, capture_output=True, text=True)
    dt = round(time.time() - t0, 3)
    ok = p.returncode == 0
    return ok, dt, (p.stdout + '\n' + p.stderr).strip()[-2000:]

for tier in ['tier1', 'tier2']:
    tdir = repo / 'contracts' / tier
    if not tdir.exists():
        continue
    for case in sorted([x for x in tdir.iterdir() if x.is_dir()]):
        cid = case.name
        exp = case / 'harness' / 'exploit.t.sol'
        pat = case / 'harness' / 'patch.t.sol'

        exploit = {'status': 'not-run'}
        patch = {'status': 'not-run'}

        if has_forge and exp.exists():
            ok, dt, log = run_forge(exp)
            exploit = {
                'status': 'pass' if ok else 'fail',
                'evidence': f'foundry://{exp.as_posix()}',
                'runtimeSeconds': dt,
                'timeToFirstValidExploitSeconds': dt if ok else None,
                'logTail': log,
            }
        elif exp.exists():
            exploit = {
                'status': 'not-run',
                'evidence': f'foundry://{exp.as_posix()}',
            }

        if has_forge and pat.exists():
            ok, dt, log = run_forge(pat)
            patch = {
                'status': 'pass' if ok else 'fail',
                'evidence': f'foundry://{pat.as_posix()}',
                'runtimeSeconds': dt,
                'logTail': log,
            }
        elif pat.exists():
            patch = {
                'status': 'not-run',
                'evidence': f'foundry://{pat.as_posix()}',
            }

        c = contracts_map[cid]
        c['exploitValidation'] = {k: v for k, v in exploit.items() if k != 'logTail' and v is not None}
        c['patchValidation'] = {k: v for k, v in patch.items() if k != 'logTail' and v is not None}

        results.append({
            'contractId': cid,
            'tier': tier,
            'exploitValidation': exploit,
            'patchValidation': patch,
        })

out_validation.write_text(json.dumps({'generatedAt': time.time(), 'hasForge': has_forge, 'contracts': results}, indent=2) + '\n')

sub['contracts'] = sorted(contracts_map.values(), key=lambda x: x['contractId'])
out_submission.write_text(json.dumps(sub, indent=2) + '\n')

print(f'wrote {out_validation}')
print(f'wrote {out_submission}')
PY
