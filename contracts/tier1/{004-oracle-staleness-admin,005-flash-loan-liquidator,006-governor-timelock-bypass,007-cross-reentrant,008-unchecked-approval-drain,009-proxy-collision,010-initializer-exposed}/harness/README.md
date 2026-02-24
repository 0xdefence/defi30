# {004-oracle-staleness-admin,005-flash-loan-liquidator,006-governor-timelock-bypass,007-cross-reentrant,008-unchecked-approval-drain,009-proxy-collision,010-initializer-exposed} realism harness

- `exploit.t.sol`: deterministic exploit success test
- `patch.t.sol`: deterministic patch validation test
- `../patched/contract.patched.sol`: mitigated contract variant

Status: scaffolded. Replace placeholders with case-specific assertions (`assertEq`, invariant break, drain delta checks).
