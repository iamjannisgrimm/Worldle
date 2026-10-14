# Simulator testing

The executable profile lives in `../config/testing.json`. Run all commands from the repository root. Requires Python 3, full Xcode and an installed iOS 26 simulator runtime. `doctor` is read-only; `prepare` creates/reuses one named disposable simulator without erasing any data.

```sh
python3 scripts/simulator.py doctor
python3 scripts/simulator.py prepare
python3 scripts/simulator.py test --udid <printed-UDID>
python3 scripts/simulator.py launch --udid <printed-UDID>
```

The helper rejects devices outside the named Worldle testing profile. DerivedData and unique run artifacts live in `~/Library/Caches/Sevolu/Worldle`, outside the iCloud repository. Each test run retains `build.log`, `tests.xcresult`, `test-summary.json` and `result.json`, including exit status, source revision, dirty state and simulator identity. A test passes only when Xcode succeeds and its result bundle reports executed, passing tests with no failures or skips. Inspect the xcresult for assertions and attached screenshots. Do not commit build output. Copy selected evidence into the project Evidence directory only when it is useful to retain for review; cache files are disposable.

## Smoke path

1. Launch the app on Worldle Agent Test. Confirm the daily city heading and map exist.
2. Tap the city heading once to enable the app's existing testing mode; this bypasses the daily lock without clearing stored preferences. Every test launches a new process so testing mode starts off.
3. Tap a point within the globe. Confirm **Confirm Guess** appears.
4. Confirm the guess and wait for the result sheet. Check **Share Result** and **Play Again**. Screenshot the result; don't send a share.
5. Tap **Play Again**. Confirm the result sheet disappears and a new game is available. Capture the reset state.

The XCUITest automates these steps. It uses existing visible labels and a point relative to the discovered map frame; it does not change production source or add a test-only service. Current limitations: app copy changes can require locator updates, the daily city changes with the date, and Apple reverse geocoding/tiles can affect latency and score. Exact scoring and offline behavior need injected fixtures and separate unit tests when those features are next worked on.

## Agent-driven exploration and video

The running Codex session must expose a native computer-use provider able to inspect the **Simulator** app. Use that provider's current documentation and fresh screen state for actions. No company JSON reference installs this provider or grants accessibility permission. XCUITest is the repeatable smoke authority; interactive exploration supplements it.

```sh
python3 scripts/simulator.py screenshot --udid <UDID>
python3 scripts/simulator.py record --udid <UDID> --seconds 20
```

Start recording before an exploratory interaction and keep it running while using the simulator. The helper sends SIGINT to its own recorder after the bounded duration. It does not tap controls, upload video or publish a PR. `record` verifies that a file was produced; a human/agent must review that it shows the intended behavior.

No account is needed. Don't borrow SeeMe test users, services or fixtures. Keep release/App Store signing separate from simulator testing.
