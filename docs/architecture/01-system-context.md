---
fitnessFunctions: ['architecture-contract', 'architecture-actors']
---

# System Context

```mermaid
C4Context
    title Stratum Observability for Swift

    Person(dev, "1 Developer")
    System(stratum, "2 Stratum", "Swift package that publishes catalogued events to the plugins an app chose.")
    System_Ext(app, "3 Host app", "The iOS or macOS app that links the package.")
    System_Ext(log, "4 Unified log", "Apple's on-device log, read in Console and Xcode.")
    System_Ext(metrickit, "5 MetricKit", "Apple's daily metric and diagnostic reports.")

    Rel(dev, app, "A")
    Rel(app, stratum, "B")
    Rel(stratum, log, "C")
    Rel(metrickit, stratum, "D")

    UpdateElementStyle(dev, $bgColor="#334155", $borderColor="#1e293b", $fontColor="#ffffff")
    UpdateElementStyle(stratum, $bgColor="#1d4ed8", $borderColor="#1e3a8a", $fontColor="#ffffff")
    UpdateElementStyle(app, $bgColor="#64748b", $borderColor="#475569", $fontColor="#ffffff")
    UpdateElementStyle(log, $bgColor="#64748b", $borderColor="#475569", $fontColor="#ffffff")
    UpdateElementStyle(metrickit, $bgColor="#64748b", $borderColor="#475569", $fontColor="#ffffff")
```

```mermaid
C4Context
    title Legend

    Person(p, "Person", "Human or agent actor")
    System(s, "System", "Software we own")
    System_Ext(e, "External", "Outside our boundary")

    UpdateElementStyle(p, $bgColor="#334155", $borderColor="#1e293b", $fontColor="#ffffff")
    UpdateElementStyle(s, $bgColor="#1d4ed8", $borderColor="#1e3a8a", $fontColor="#ffffff")
    UpdateElementStyle(e, $bgColor="#64748b", $borderColor="#475569", $fontColor="#ffffff")
```

Numbers on nodes and letters on arrows match the callout table.

| #   | Description | Why |
| --- | --- | --- |
| 1   | Writes an app, its catalog of events, and the plugins it publishes to. | Requirements name this actor in a Given. |
| 2   | The `Stratum` library and its plugin products. | One way to publish, whatever the destination. |
| 3   | The app a person uses, which links the package. | Events start from what a person does there. |
| 4   | Apple's unified log, through `Logger`. | Local diagnostics with no server, the first plugin in the Plan's order. |
| 5   | Apple's MetricKit, which delivers reports at most once a day. | Launch, memory, crash and hang numbers with no server, second in the order. |
| A   | The developer builds the app with the package. | The app chooses its catalogs and plugins. |
| B   | The app publishes events by key. | One call per event, checked against the catalog. |
| C   | The OSLog plugin writes each event. | It lands beside the app's own `Logger` lines. |
| D   | MetricKit delivers its reports to the MetricKit source. | Reports become events every plugin sees. |
