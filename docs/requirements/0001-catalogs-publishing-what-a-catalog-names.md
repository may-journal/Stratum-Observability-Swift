---
relatedConfigurations: ['../../.fitnessrc.json']
---

# 0001 Publishing what a catalog names

## Why

My app publishes only the events I wrote down in a catalog, so every event my team reads has one known meaning.

## Measurement

published keys that reach my plugins from a catalog that holds them

-

published keys

## Requirements

- 0001.1
    - Given Developer has a catalog holding an event
        - When a person's tap publishes it
            - Then my plugin receives that event
- 0001.2
    - Given Developer has no event under a key
        - When I publish that key
            - Then my plugin receives nothing
- 0001.3
    - Given Developer adds a catalog after start
        - When I publish one of its events
            - Then my plugin receives it from that catalog
- 0001.4
    - Given Developer removes a catalog
        - When I publish one of its events
            - Then my plugin receives nothing
- 0001.5
    - Given Developer has an event key with a space
        - When I add its catalog
            - Then adding fails and names the event
- 0001.6
    - Given Developer has a key another catalog holds
        - When I add the catalog
            - Then adding fails and names the other catalog
