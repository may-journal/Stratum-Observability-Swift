### 2026.11.23.1505

> Every pull request builds the package and runs its requirement tests.

- Ci: the new `Swift` workflow runs `swift build` and `swift test` on pull requests and on pushes to main.
- Ci: the job uses the `xcode-27` image, since the UI testing dependency needs the macOS 27 SDK.
- Docs: `CONTRIBUTING.md` names the workflow in its Checks section.
