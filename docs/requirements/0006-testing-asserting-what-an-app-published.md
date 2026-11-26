# 0006 Asserting what an app published

## Why

My app's tests read which events it published, without my writing a plugin to keep them.

## Measurement

published events the recorder holds in publishing order

-

events published through the recorder

## Requirements

1. Records in order
   1. GIVEN Developer adds the recorder to my tests
      1. WHEN I publish two events
         1. THEN the recorder lists both keys in order
2. Filters by key
   1. GIVEN Developer publishes two different events
      1. WHEN I ask the recorder for one key
         1. THEN I get only that key's snapshots
3. Resets
   1. GIVEN Developer resets the recorder after one event
      1. WHEN I publish another event
         1. THEN the recorder holds only the newer one
