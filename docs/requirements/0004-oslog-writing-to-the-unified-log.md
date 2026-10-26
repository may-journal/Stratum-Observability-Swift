---
relatedConfigurations: ['../../.fitnessrc.json']
---

# 0004 Writing to the unified log

## Why

My events land in Apple's unified log beside my own `Logger` lines, and what a person wrote stays private there.

## Measurement

published events the unified log holds under my subsystem with private fields hidden

-

events published through the OSLog plugin

## Requirements

- 0004.1
    - Given Developer uses the OSLog plugin with my subsystem
        - When I publish through it
            - Then the log holds it under the event's category
- 0004.2
    - Given Developer has an error event
        - When I publish the error
            - Then the log entry has the error level
- 0004.3
    - Given Developer passes a public field
        - When I log the event
            - Then the log entry shows its value
- 0004.4
    - Given Developer passes a private field
        - When I log that private field
            - Then the log entry hides its value
