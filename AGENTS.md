# Worldle

Small SwiftUI daily-city guessing app. Read [the project guide](../../AGENTS.md) and [Sevolu](../../../../AGENTS.md) when working in this company checkout. If cloned independently, use this guide and README.md; company paths are optional context outside the standalone clone.

- App source is `Worldle/`; Xcode project/scheme is `Worldle`. Read the relevant layer only: Views, ViewModels, Services or Models. The Xcode project currently requires iOS 26; older source README platform claims are historical.
- For implementation, establish current behavior first, make the smallest coherent change, then verify that behavior. Avoid introducing a backend, framework, abstraction or dependency for this small app unless the task needs it.
- For build, simulator interaction, UI verification or test work, read [worldle-testing](.agents/skills/worldle-testing/SKILL.md). Its source of truth is [config/testing.json](config/testing.json), with the procedure in [docs/testing.md](docs/testing.md). Do not claim a build proves a UI flow works.
- Shared coding/testing skills resolve through the project's company catalog. They are optional outside the company workspace; this repository's own testing procedure remains self-contained.
- Before completion, run the applicable checks and make a local Git commit containing only task-owned changes. Report the commit and evidence paths. Publishing, pushing, release signing and App Store actions are separate tasks.
- Never store credentials here. No user account is required for the local game. MapKit tiles and reverse geocoding may require network access. Use the dedicated Worldle simulator for smoke tests; preserve other simulators and their app data.
