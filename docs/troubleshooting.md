# Troubleshooting

Run `agentdev doctor`. If a provider is missing, authenticate it with its
official CLI and rerun `agentdev update`. If RuleSync reports drift, run its
`generate --check` from the installed template. Existing projects are never
rewritten by `newdev`.
