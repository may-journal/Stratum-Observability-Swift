### 2026.11.23.1440

> An app's tests assert what it published with the shipped `Recorder` plugin.

- Feat: the new `StratumTesting` product holds `Recorder`, a thread-safe plugin that keeps each snapshot in order.
- Feat: `keys`, `last`, `snapshots(for:)` and `reset()` let a test read published events in one line.
- Docs: requirement 0006 names three acceptances, and the package's own tests use the shipped recorder.
