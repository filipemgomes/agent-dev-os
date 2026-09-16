# Installation

Run `./install.ps1` from a clone. Defaults are `$env:USERPROFILE\.dev-agent`
and `C:\dev`; pass `-InfrastructureRoot` or `-ProjectRoot` to customize them.
The installer installs only missing Node-based prerequisites, backs up changed
configuration, registers the native Context Mode plugin once, generates
RuleSync targets, and runs the doctor.
