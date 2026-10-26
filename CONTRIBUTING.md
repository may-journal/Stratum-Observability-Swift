# Contributing

Every change starts from an issue. A change in behavior needs an approved Plan issue, and its pull request closes that Plan.

Contributions are licensed under the Apache License 2.0, as the rest of the project.

## Build and test

You need Xcode 26 or later on a Mac.

```sh
swift build
swift test
```

`swift test` runs one Swift Testing suite per [requirement doc](docs/requirements). Each test publishes from a button a person taps, as an app does. It then reads what the plugin received or the log holds.

## Checks

The org's Fitness suite runs on every pull request. Run it locally through the shared hooks, as the [Fitness CI guide](https://github.com/may-journal/fitness-runner/blob/main/docs/ci.md) describes:

```sh
git config --local core.hooksPath .fitness-hooks
"$HOME/.local/share/may-journal/fitness/fitness-install" --version latest
```

SwiftLint reads `.swiftlint.yml`. Wrap long lines with swift-format:

```sh
xcrun swift-format format --in-place --recursive --configuration .swift-format Sources Tests
```

## Pull requests

- Add one `changelog/<yyyy-mm-dd-HHMM>-<change>.md` entry and link it from the description.
- Change a requirement doc and its test together.
- Keep the architecture views in step with the sources they name.
