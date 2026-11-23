# 0006 Asserting what an app published

## Why

My app's tests read which events it published, without my writing a plugin to keep them.

## Measurement

published events the recorder holds in publishing order

-

events published through the recorder

## Requirements

- 0006.1
    - Given Developer adds the recorder to my tests
        - When I publish two events
            - Then the recorder lists both keys in order
- 0006.2
    - Given Developer publishes two different events
        - When I ask the recorder for one key
            - Then I get only that key's snapshots
- 0006.3
    - Given Developer resets the recorder after one event
        - When I publish another event
            - Then the recorder holds only the newer one
