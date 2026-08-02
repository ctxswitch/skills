# Capture Rules

Use this before writing project context.

## What to Capture

Capture only durable knowledge that will help future work:

- project-specific domain terms
- canonical names and aliases to avoid
- relationships between domain concepts
- critical distributed invariants
- chosen guarantees for specific workflows
- hard-to-reverse architecture decisions
- surprising tradeoffs and their rationale

Do not capture generic distributed-systems concepts like "quorum," "cache," "leader election," or "idempotency" unless the project gives them a specific meaning.

## Context Updates

Look first for:

- root `CONTEXT.md`, then each nested `CONTEXT.md` down to the area
- nearby design docs

If a context file exists and the drill resolves a domain term or invariant, update it immediately.

Use this shape:

```markdown
## Language

**Term**: One-sentence canonical definition.
_Avoid_: Ambiguous alias, misleading alias
_Fixed_: the constraint that holds, and the alternative it rules out

## Relationships

- A **Term** owns many **Other Terms**.

## Invariants

- **Invariant Name**: Statement of the invariant, its scope, and enforcement mechanism.

## Decisions

- The constraint — the alternative rejected, and why it would still look right
```

Write the entry at the shallowest directory where it holds for everything beneath it. If the level is unclear, ask before writing.

## Decision Threshold

Record a decision only while someone would still reach for the alternative. Name who would propose it and what would make it look right; if you cannot, the outcome recorded elsewhere is enough.

Distributed-systems choices that usually clear that bar:

- choosing availability over a global invariant under partition
- choosing single-writer ownership instead of multi-primary replication
- requiring quorum writes for acknowledged durability
- introducing a consensus system or distributed lock service
- choosing async eventual completion over synchronous commit
- changing tenant isolation or authorization propagation

Write it as `_Fixed_:` on the term it governs, or under `## Decisions` when it governs no single term.
