# Domain Docs

How the engineering skills should consume this repo's domain documentation when exploring the codebase.

## Before exploring, read these

- **`CONTEXT.md`** from the repo root down to the area you're working in — every level assumes its ancestors.
- **`CONTEXT-MAP.md`** at the repo root if it exists — cross-cutting relationships between sibling areas.
- **`docs/adr/`** — read ADRs that touch the area you're about to work in, including any `docs/adr/` nested under it.

If any of these files don't exist, **proceed silently**. Don't flag their absence; don't suggest creating them upfront.
The producer skill (`grill-me`) creates them lazily when terms or decisions actually get resolved.

## File structure

Context files form a hierarchy — one per directory that owns language, each describing only its own level.

```
/
├── CONTEXT.md                the product
├── CONTEXT-MAP.md            cross-cutting relationships only
├── docs/adr/                 system-wide decisions
└── src/
    ├── CONTEXT.md            what the areas are
    └── ordering/
        ├── CONTEXT.md        the ordering domain
        └── docs/adr/         area-scoped decisions
```

## Use the glossary's vocabulary

When your output names a domain concept (in an issue title, a refactor proposal, a hypothesis, a test name), use the term as defined in `CONTEXT.md`.
Don't drift to synonyms the glossary explicitly avoids.

If the concept you need isn't in the glossary yet, that's a signal — either you're inventing language the project doesn't use (reconsider) or there's a real gap (note it for `grill-me`).

## Flag ADR conflicts

If your output contradicts an existing ADR, surface it explicitly rather than silently overriding:

> _Contradicts ADR-0007 (event-sourced orders) — but worth reopening because…_
