---
relatedConfigurations: ['../../.fitnessrc.json']
---

# 0005 Publishing the system's reports

## Why

The metric and diagnostic reports the system delivers reach my plugins as events, with no server of my own.

## Measurement

MetricKit reports that reach my plugins as events

-

MetricKit reports delivered to the app

## Requirements

- 0005.1
    - Given Developer uses the MetricKit source
        - When the system delivers a metric report
            - Then my plugin receives its period and peak memory
- 0005.2
    - Given Developer uses the MetricKit source
        - When the system delivers a crash and a hang
            - Then my plugin receives one event for each
- 0005.3
    - Given Developer uses the MetricKit source
        - When it receives JSON that is not a report
            - Then my plugin receives nothing
