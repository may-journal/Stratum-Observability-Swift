---
fitnessFunctions: ['architecture-contract', 'architecture-journey']
---

# User Journey

## Legend

```mermaid
flowchart TB
    subgraph types["Node types"]
        persona((1 Persona)):::persona
        screen[2 Screen]:::screen
        action(3 Action):::action
        system[(4 System)]:::system
    end

    classDef persona fill:#eef2ff,stroke:#6366f1,color:#312e81,stroke-width:2px
    classDef screen fill:#f8fafc,stroke:#64748b,color:#1e293b,stroke-width:2px
    classDef action fill:#fff7ed,stroke:#f97316,color:#9a3412,stroke-width:2px
    classDef system fill:#ecfdf5,stroke:#10b981,color:#064e3b,stroke-width:2px
```

Numbers match the callout table.

| #   | Description | Why |
| --- | ----------- | --- |
| 1   | Persona     | A person the system context declares. |
| 2   | Screen      | What the person sees. |
| 3   | Action      | What the person does. |
| 4   | System      | What the product does in reply. |

## Journey

```mermaid
flowchart TB
    dev((1 Developer)):::persona
    catalog(2 Write a catalog<br/>Req 0001):::action
    plugins(3 Choose plugins<br/>Req 0003):::action
    tap(4 A person's tap publishes<br/>Req 0001, 0002):::action
    snapshot[(5 Event frozen with context<br/>Req 0002)]:::system
    log[6 Entry in the unified log<br/>Req 0004]:::screen
    report[(7 System report published<br/>Req 0005)]:::system

    dev --> catalog
    catalog --> plugins
    plugins --> tap
    tap --> snapshot
    snapshot --> log
    plugins --> report
    report --> log

    classDef persona fill:#eef2ff,stroke:#6366f1,color:#312e81,stroke-width:2px
    classDef screen fill:#f8fafc,stroke:#64748b,color:#1e293b,stroke-width:2px
    classDef action fill:#fff7ed,stroke:#f97316,color:#9a3412,stroke-width:2px
    classDef system fill:#ecfdf5,stroke:#10b981,color:#064e3b,stroke-width:2px
```

Numbers match the callout table.

| #   | Description | Type | Why |
| --- | ----------- | ---- | --- |
| 1   | The developer. | Persona | Same person as the system context. |
| 2   | Writes the catalog of events the app may publish. | Action | Only catalogued keys publish. |
| 3   | Adds the OSLog plugin and the MetricKit source. | Action | The Plan's first two plugins, both local. |
| 4   | A person uses the app, and its code publishes a key. | Action | Events start from what a person does. |
| 5   | Stratum freezes the event with its context and session. | System | Every plugin reads the same value. |
| 6   | The developer reads the entry in Console or Xcode. | Screen | Private fields stay hidden there. |
| 7   | MetricKit's daily report becomes events. | System | Crashes and hangs show beside the app's own events. |
