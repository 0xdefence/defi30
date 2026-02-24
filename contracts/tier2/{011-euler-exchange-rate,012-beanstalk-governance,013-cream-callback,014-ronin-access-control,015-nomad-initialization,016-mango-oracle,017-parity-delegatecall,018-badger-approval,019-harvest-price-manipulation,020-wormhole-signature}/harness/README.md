# {011-euler-exchange-rate,012-beanstalk-governance,013-cream-callback,014-ronin-access-control,015-nomad-initialization,016-mango-oracle,017-parity-delegatecall,018-badger-approval,019-harvest-price-manipulation,020-wormhole-signature} realism harness

- `exploit.t.sol`: deterministic exploit success test
- `patch.t.sol`: deterministic patch validation test
- `../patched/contract.patched.sol`: mitigated contract variant

Status: scaffolded. Replace placeholders with case-specific assertions (`assertEq`, invariant break, drain delta checks).
