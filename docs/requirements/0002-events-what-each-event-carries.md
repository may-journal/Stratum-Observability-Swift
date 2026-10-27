# 0002 What each event carries

## Why

Each event tells me where the app was and which launch it came from, and carries only the fields I allowed.

## Measurement

published events that carry the context and only allowed fields

-

published events

## Requirements

- 0002.1
    - Given Developer has set a context value
        - When I publish after setting it
            - Then the event carries that value
- 0002.2
    - Given Developer passes a field the event does not name
        - When I publish with that field
            - Then the event leaves that field out
- 0002.3
    - Given Developer has two services in one launch
        - When I publish from each
            - Then both events share one session
- 0002.4
    - Given Developer has added a listener
        - When I publish through the service
            - Then the listener receives it
