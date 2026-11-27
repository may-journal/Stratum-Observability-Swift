# 0001 Publishing what a catalog names

## Why

My app publishes only the events I wrote down in a catalog, so every event my team reads has one known meaning.

## Measurement

published keys that reach my plugins from a catalog that holds them

-

published keys

## Requirements

1. Publishes held events
   1. GIVEN Developer has a catalog holding an event
      1. WHEN a person's tap publishes it
         1. THEN my plugin receives that event
2. Drops unknown keys
   1. GIVEN Developer has no event under a key
      1. WHEN I publish that key
         1. THEN my plugin receives nothing
3. Adds catalogs after start
   1. GIVEN Developer adds a catalog after start
      1. WHEN I publish one of its events
         1. THEN my plugin receives it from that catalog
4. Removes catalogs
   1. GIVEN Developer removes a catalog
      1. WHEN I publish one of its events
         1. THEN my plugin receives nothing
5. Rejects keys with spaces
   1. GIVEN Developer has an event key with a space
      1. WHEN I add its catalog
         1. THEN adding fails
         2. THEN it names the event
6. Rejects duplicate keys
   1. GIVEN Developer has a key another catalog holds
      1. WHEN I add the catalog
         1. THEN adding fails
         2. THEN it names the other catalog
