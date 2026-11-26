# 0003 Choosing where events go

## Why

I choose which plugins receive my events, and each plugin takes only the events it wants.

## Measurement

plugins that receive exactly the events they accept

-

plugins

## Requirements

1. Adds plugins after start
   1. GIVEN Developer adds a plugin after start
      1. WHEN I publish an event
         1. THEN that plugin receives it
2. Filters by level
   1. GIVEN Developer has a plugin that takes only errors
      1. WHEN I publish an info event
         1. THEN that plugin receives nothing
3. Replaces same-name plugins
   1. GIVEN Developer adds a second plugin with the same name
      1. WHEN I publish once
         1. THEN only the second plugin receives it
