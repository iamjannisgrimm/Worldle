---
name: worldle-testing
description: Supply Worldle's simulator setup, commands and game scenarios for build, UI testing and implementation verification. Use with the shared simulator-ui-testing procedure when available.
---

# Worldle testing

Work from the repository root (three levels above this skill directory). Read [repository guidance](../../../AGENTS.md), [the test profile](../../../config/testing.json) and [the testing guide](../../../docs/testing.md).

For the common baseline → UI verification → evidence workflow, read [shared simulator UI testing](../../../../../../../../Workspace/Skills/simulator-ui-testing/SKILL.md) (`shared.skills:simulator-ui-testing`). Resolve it through the company catalog or the installed `simulator-ui-testing` skill if this checkout is elsewhere. An independent clone can still execute the complete local smoke procedure in docs/testing.md; report shared guidance as unavailable if it cannot be read.

## Worldle inputs

- `config/testing.json` owns scheme, app identity, intended simulator, fixtures, evidence destination and known coverage gaps. No account or MCP server is needed for the local game. MapKit imagery/geocoding may use Apple services; do not borrow SeeMe fixtures or accounts.
- From the repository root, run `python3 scripts/simulator.py doctor`, then `prepare` to create/reuse the dedicated **Worldle Agent Test** simulator. Use the exact printed UDID for `test --udid <UDID>`, `launch --udid <UDID>`, `screenshot --udid <UDID>` and bounded `record --udid <UDID> --seconds 20` operations. The helper rejects other devices; do not erase or substitute one to bypass failures.
- `test` builds and runs the actual XCUITest, retaining the log, xcresult and result receipt. `docs/testing.md` owns the smoke scenario: enable the existing testing mode, choose a globe location, confirm the guess, inspect the result, then replay. Share-sheet checks remain local.
- Interactive taps require the active session's native Simulator computer-use provider (`company.tools:worldle-ui-control`). The simulator helper (`company.tools:worldle-simulator`) does not tap controls. If UI control is unavailable, report interactive checks as skipped/blocked separately from XCUITest results.
- Do not infer exact scoring, daily-lock persistence, offline correctness, full iPad or accessibility coverage from this smoke test. Review result artifacts and keep failed checks visible. Follow repository guidance for local commits; pushes and releases need their own authorization.

This repo owns these Worldle inputs. The company registry only indexes this file and declares its dependency on the single shared procedure; native discovery finds this skill in .agents/skills.
