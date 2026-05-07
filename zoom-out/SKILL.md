---
name: zoom-out
description: "Give a higher-level map of unfamiliar code, modules, callers, boundaries, and domain concepts before changing anything. Use when the user asks to zoom out, understand how an area fits into the larger system, map relevant modules and callers, or explain code at a broader abstraction level."
disable-model-invocation: true
---

# Zoom Out

When this skill is invoked, step back from implementation details and explain the surrounding system.

## Behavior

- Inspect relevant code and docs before answering.
- Use project domain vocabulary from `CONTEXT.md`, `CONTEXT-MAP.md`, ADRs, and nearby docs when available.
- Identify the main modules, interfaces, callers, data flow, ownership boundaries, and external dependencies.
- Explain how the target area fits into the broader feature or domain.
- Call out uncertainty and where deeper inspection would be needed.
- Do not modify code unless the user explicitly asks after the map.

## Output Shape

```markdown
## Big Picture

## Relevant Modules

## Callers And Entry Points

## Data Flow

## Boundaries And Dependencies

## What To Inspect Next
```
