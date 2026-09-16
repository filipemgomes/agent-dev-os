# Security

Agent Dev OS never needs credentials in this repository. Authenticate providers
locally through their official tools. Never commit API keys, OAuth tokens,
cookies, credential stores, or local auth files. The installer backs up existing
configuration before changing it and does not enable unrestricted sandbox,
`approval_policy=never`, `danger-full-access`, auto-push, or auto-delete.

Report security issues privately to the repository maintainers before public
disclosure.
