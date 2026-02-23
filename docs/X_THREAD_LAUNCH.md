1/ DeFi-30 is live: an open benchmark for DeFi smart contract security detection.

The exam is public. Any tool can take it.

https://github.com/0xdefence/defi30

2/ Why this exists:
Most benchmarks underweight the vuln classes that caused major DeFi losses.

DeFi-30 focuses on:
- oracle/price manipulation
- governance abuse
- reentrancy/callback patterns
- signature/access-control failures

3/ Structure:
- Tier 1: synthetic isolated patterns
- Tier 2: real exploit recreations
- Tier 3: public audit-derived complexity

4/ Scoring (transparent):
- Detection 50%
- Precision 30%
- Severity accuracy 20%

5/ We’ve published initial scaffolding + implemented Tier2 cases (011,012,015,016,020).
More cases shipping continuously.

6/ If you build a security tool (AI/static/hybrid), run it and submit your JSON.

We’ll list results on the open leaderboard.

7/ Repo + docs:
- methodology
- taxonomy
- scoring spec
- submission example

https://github.com/0xdefence/defi30
