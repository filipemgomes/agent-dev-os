# Universal workflow

- Read canonical instructions and check Git before acting.
- Continue an `in_progress` task by default.
- Reconstruct state from code, tests, Git, ADRs, and docs when they disagree.
- Consult current documentation automatically for external libraries and APIs.
- Use the smallest useful delegation; do not create teams for trivial edits.
- For a new feature, ambiguous product change, architecture change, or substantial behavior change, prefer `grill-with-docs` before implementation unless canonical docs already resolve the design or the user explicitly asks to skip grilling. Never re-grill frozen decisions without a concrete reason.
- Use Matt Pocock workflow skills as composable engineering tools: `to-spec` to synthesize an agreed design, `to-tickets` when work benefits from tracer-bullet decomposition, `implement` for spec-driven execution, and model-invoked TDD/domain-modeling/code-review/diagnosis when the task fits.
- For any task that creates or materially changes UI/frontend, activate the `ui-product-design` skill before writing UI code and follow its rendered-browser completion gate.
- Update `.agent/current.json` at meaningful milestones.
