# 0007 Sharing a diagnostics file

## Why

My app keeps its events in a file on the device, so a person can share that file with me.

## Measurement

published events the file holds as JSON lines with private values left out

-

events published through the file plugin

## Requirements

- 0007.1
    - Given Developer uses the file plugin with my file
        - When I publish an event
            - Then the file holds one JSON line with its key
- 0007.2
    - Given Developer passes a private field
        - When I publish that private field
            - Then the file names the field without its value
- 0007.3
    - Given Developer sets a small size cap
        - When I publish past the cap
            - Then earlier lines move to one older file
