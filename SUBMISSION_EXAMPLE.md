# Submission Example

```json
{
  "toolName": "ExampleTool",
  "toolVersion": "v0.2.1",
  "timestamp": "2026-02-23T00:00:00Z",
  "contracts": [
    {
      "contractId": "001-reentrancy-vault",
      "findings": [
        {
          "title": "Reentrancy in withdraw",
          "class": "reentrancy",
          "severity": "critical",
          "location": "withdraw()",
          "description": "External call before balance update",
          "confidence": 0.94
        }
      ]
    }
  ]
}
```

Run:
```bash
bun run src/cli.ts score ./my-submission.json
```
