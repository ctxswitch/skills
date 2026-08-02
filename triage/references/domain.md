# Domain Docs

How the engineering skills should consume this repo's domain documentation when exploring the codebase.

## Before exploring, read these

- **`.context.md`** from the repo root down to the area you're working in — every level assumes its ancestors.

If these files don't exist, **proceed silently**. Don't flag their absence; don't suggest creating them upfront.
`context` builds and repairs them; `grill-me` adds to them as terms get resolved.

## File structure

Context files form a hierarchy — one per directory that owns language, each describing only its own level.

```
/
├── .context.md                the product
└── src/
    ├── .context.md            what the areas are
    └── ordering/
        └── .context.md        the ordering domain
```

## Use the glossary's vocabulary

When your output names a domain concept (in an issue title, a refactor proposal, a hypothesis, a test name), use the term as defined in `.context.md`.
Don't drift to synonyms the glossary explicitly avoids.

If the concept you need isn't in the glossary yet, that's a signal — either you're inventing language the project doesn't use (reconsider) or there's a real gap (note it for `grill-me`).

## Flag decision conflicts

If your output contradicts a decision recorded in context, surface it explicitly rather than silently overriding:

> _Contradicts the recorded decision that orders are event-sourced — but worth reopening because…_
