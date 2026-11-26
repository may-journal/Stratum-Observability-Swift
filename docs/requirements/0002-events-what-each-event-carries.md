# 0002 What each event carries

## Why

Each event tells me where the app was and which launch it came from, and carries only the fields I allowed.

## Measurement

published events that carry the context and only allowed fields

-

published events

## Requirements

1. Carries context
   1. GIVEN Developer has set a context value
      1. WHEN I publish after setting it
         1. THEN the event carries that value
2. Leaves out unnamed fields
   1. GIVEN Developer passes a field the event does not name
      1. WHEN I publish with that field
         1. THEN the event leaves that field out
3. Shares one session
   1. GIVEN Developer has two services in one launch
      1. WHEN I publish from each
         1. THEN both events share one session
4. Tells listeners
   1. GIVEN Developer has added a listener
      1. WHEN I publish through the service
         1. THEN the listener receives it
