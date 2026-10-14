# Worldle App

A daily city guessing game.

Currently waiting for this to be releasable on the appstore.
Once on RC will be uploaded.

## Development

See [AGENTS.md](AGENTS.md) for repository guidance and [docs/testing.md](docs/testing.md) for the simulator workflow. The shared Worldle scheme includes a small UI smoke test; `python3 scripts/simulator.py doctor` checks prerequisites. The current project targets iOS 26.

This checkout belongs to [Sevolu / Worldle](../../AGENTS.md). Its repo-owned skill is in `.agents/skills/worldle-testing`; it is also explicitly linked from the company registry so an agent starting at Sevolu can discover it.
