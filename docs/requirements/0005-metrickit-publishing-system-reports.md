# 0005 Publishing the system's reports

## Why

The metric and diagnostic reports the system delivers reach my plugins as events, with no server of my own.

## Measurement

MetricKit reports that reach my plugins as events

-

MetricKit reports delivered to the app

## Requirements

1. Publishes metric reports
   1. GIVEN Developer uses the MetricKit source
      1. WHEN the system delivers a metric report
         1. THEN my plugin receives its period
         2. THEN my plugin receives its peak memory
2. Publishes crashes and hangs
   1. GIVEN Developer uses the MetricKit source
      1. WHEN the system delivers a diagnostic report
         1. THEN my plugin receives one event for the crash
         2. THEN my plugin receives one event for the hang
3. Ignores other JSON
   1. GIVEN Developer uses the MetricKit source
      1. WHEN it receives JSON that is not a report
         1. THEN my plugin receives nothing
