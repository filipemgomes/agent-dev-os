# Agent instructions

Read `CONTEXT.md`, inspect `git status` and `git diff`, then continue any task
whose `.agent/current.json` status is `in_progress`. Do not ask for context
recoverable from Git, code, tests, ADRs, or task state.

Use current external documentation when library/API behavior matters. Implement
relevant changes with tests and update `.agent/current.json` at meaningful
milestones.

Precedence: code and tests > ADRs > task state > project docs > agent rules >
session memory.
