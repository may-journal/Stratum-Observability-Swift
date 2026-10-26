# Stratum Observability for Swift

An iOS or macOS app writes its events down in a catalog. Stratum publishes each one to the plugins the app chose. Every event has one key, one meaning, and a list of the fields it may carry.

This is the Swift edition. The TypeScript edition lives in [may-journal/Stratum-Observability](https://github.com/may-journal/Stratum-Observability), forked from Capital One's [Stratum Observability](https://github.com/capitalone/Stratum-Observability).

## Products

| Product | What it does |
| --- | --- |
| `Stratum` | Catalogs, context, listeners and publishing. It needs no plugin of its own. |
| `StratumOSLog` | Writes each event to Apple's unified log, under the app's subsystem and the event's category. |
| `StratumMetricKit` | Publishes the metric and diagnostic reports MetricKit delivers as events. |

Plugins are built in the order [Plan #1](https://github.com/may-journal/Stratum-Observability-Swift/issues/1) set. The two local ones come first and need no server. Optional remote plugins, such as Sentry, TelemetryDeck and OpenTelemetry, come later, and only an app that chooses them sends data off the device.

## Install

Add the package to `Package.swift`, or in Xcode choose File, then Add Package Dependencies:

```swift
.package(url: "https://github.com/may-journal/Stratum-Observability-Swift", branch: "main")
```

Then link `Stratum` and the plugin products the app uses. It needs iOS 26 or macOS 26 and Swift 6.2.

## Use

Write a catalog, start one service with the app's plugins, and publish by key. An event's category can match a `Logger` category the app already uses, so its entries sit beside the app's own lines.

```swift
import Stratum
import StratumMetricKit
import StratumOSLog

let catalog = Catalog(
    name: "Notes", version: "1.0",
    events: [
        "note.saved": Event(
            "A person saved a note", category: "editor",
            publicFields: ["words"], privateFields: ["title"]),
        "sync.failed": Event("The notes failed to sync", category: "sync", level: .error),
    ])

let stratum = try Stratum(
    product: "Notes", version: "2.1", catalogs: [catalog],
    plugins: [OSLogPlugin(subsystem: "com.example.notes")])
let metrics = try MetricKitSource(stratum: stratum)  // keep it for the app's lifetime
metrics.start()

stratum.setContext("Today", for: "screen")
stratum.publish("note.saved", fields: ["words": "120", "title": "Dentist at noon"])
```

- A key no catalog holds publishes nothing, and `publish` returns false.
- A field the event does not name is dropped.
- Public fields read in the clear in the log; private fields are redacted.
- Context is public, so keep what a person wrote out of it.
- A plugin is any type that conforms to `Plugin`. Adding a second plugin with the same name replaces the first.

## Docs

- [Requirements](docs/requirements): what the package promises, one test for each acceptance.
- [Architecture](docs/architecture): the five views, from system context to user journey.
- [Contributing](CONTRIBUTING.md): how to build, test and check a change.

## License

Apache 2.0, as the upstream project. See [LICENSE](LICENSE).
