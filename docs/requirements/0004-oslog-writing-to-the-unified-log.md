# 0004 Writing to the unified log

## Why

My events land in Apple's unified log beside my own `Logger` lines, and what a person wrote stays private there.

## Measurement

published events the unified log holds under my subsystem with private fields hidden

-

events published through the OSLog plugin

## Requirements

1. Logs under the category
   1. GIVEN Developer uses the OSLog plugin with my subsystem
      1. WHEN I publish through it
         1. THEN the log holds it under the event's category
2. Logs errors at error level
   1. GIVEN Developer has an error event
      1. WHEN I publish the error
         1. THEN the log entry has the error level
3. Shows public fields
   1. GIVEN Developer passes a public field
      1. WHEN I log the event
         1. THEN the log entry shows its value
4. Hides private fields
   1. GIVEN Developer passes a private field
      1. WHEN I log that private field
         1. THEN the log entry hides its value
