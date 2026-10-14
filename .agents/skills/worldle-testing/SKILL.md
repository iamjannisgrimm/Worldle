---
name: worldle-testing
description: Build Worldle, run its simulator UI smoke test, explore game flows, and collect local evidence. Use for Worldle implementation verification and simulator testing.
---

# Worldle testing

Work from the repository root (three levels above this skill directory). Read `AGENTS.md`, `config/testing.json` and `docs/testing.md`.

1. Run `python3 scripts/simulator.py doctor`. Distinguish installed Xcode/runtimes from a session's actual ability to inspect/click UI. No account or MCP server is needed for the local game.
2. Run `python3 scripts/simulator.py prepare` to create/reuse the dedicated **Worldle Agent Test** simulator. It prints the exact UDID; subsequent commands require it. Never substitute a personal or SeeMe simulator or erase one to resolve a failure.
3. For a baseline or after a relevant change, run `python3 scripts/simulator.py test --udid <UDID>`. This builds and executes the real XCUITest against the app, retaining the build log, xcresult, screenshot attachments and a result receipt. A failed check must stay failed in the report.
4. For exploratory work, run `python3 scripts/simulator.py launch --udid <UDID>`, then use the current session's native Simulator computer-use capability. Discover its documented API, inspect the current screen/hierarchy before each action, and verify the resulting state. Prefer actual element labels; use coordinates only from a fresh screenshot when the globe has no semantic hit target. If UI control is unavailable, report it; simctl alone cannot click through the app.
5. Follow the smoke path in `docs/testing.md`. Run focused additional scenarios appropriate to the change. Do not infer full scoring, persistence or offline correctness from the smoke pass. Keep share-sheet checks local; opening the sheet does not authorize sending a result.
6. Report source revision/dirty state, UDID/runtime, command, passed/failed/skipped checks, and artifact paths. Use `record --udid <UDID> --seconds 20` for a bounded local video when the task needs it; this captures pixels and does not assert behavior. Review the diff, then locally commit the requested change.

No global Codex configuration, backend credentials or automatic publishing are part of this procedure. The registry references this canonical skill; native discovery also works when Codex opens this repository's `.agents/skills`.
