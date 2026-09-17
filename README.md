# Agent Dev OS

One agent-native development environment. Any coding agent.

OpenCode + Oh My OpenAgent + Context Mode + Context7 + RuleSync provide one
natural-language workflow while Claude Code, Codex CLI, Kimi Code, and future
providers remain available as executors.

## Install

On a new Windows machine, install Git, Node.js/npm, and use PowerShell.

```powershell
git clone https://github.com/filipemgomes/agent-dev-os.git
cd agent-dev-os
.\install.ps1
```

Close and reopen PowerShell so the installed `newdev` and `agentdev` commands
are available on the updated user PATH. Then check the installation and create
a project:

```powershell
agentdev doctor
newdev minha-ideia -NoOpen
cd C:\dev\minha-ideia
opencode
```

For an existing project:

```powershell
cd projeto
opencode
```

Use `continue` or any natural instruction. Run `agentdev doctor` to inspect the
installation.

## What it does not do

- Provide paid models or share credentials.
- Remove sandbox or permission safeguards.
- Promise eternal provider compatibility.
- Replace Git or project documentation.

## Acknowledgements

Agent Dev OS bootstraps OpenCode, Oh My OpenAgent, Context Mode, Context7,
RuleSync, and Agent Skills-compatible workflows. Each upstream project keeps
its own license and runtime; this repository does not copy their code.
