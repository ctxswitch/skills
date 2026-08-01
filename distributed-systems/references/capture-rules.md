# Capture Rules

Use this before writing project context or proposing an ADR.

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

- `CONTEXT-MAP.md`
- root `CONTEXT.md`
- nested `CONTEXT.md`
- nearby design docs

If a context file exists and the drill resolves a domain term or invariant, update it immediately.

Use this shape:

```markdown
## Language

**Term**: One-sentence canonical definition.
_Avoid_: Ambiguous alias, misleading alias

## Relationships

- A **Term** owns many **Other Terms**.

## Invariants

- **Invariant Name**: Statement of the invariant, its scope, and enforcement mechanism.
```

For multi-context repos, update the nearest relevant `CONTEXT.md`. If the relevant context is unclear, ask before writing.

## ADR Threshold

Offer an ADR only when all are true:

- Hard to reverse: changing later would be meaningfully expensive.
- Surprising without context: future maintainers would wonder why this choice was made.
- Real tradeoff: credible alternatives existed and one was chosen for a reason.

Distributed-systems examples that are often ADR-worthy:

- choosing availability over a global invariant under partition
- choosing single-writer ownership instead of multi-primary replication
- requiring quorum writes for acknowledged durability
- introducing a consensus system or distributed lock service
- choosing async eventual completion over synchronous commit
- changing tenant isolation or authorization propagation

## ADR Skeleton

```markdown
# ADR: {Decision}

## Status

Proposed|Accepted|Superseded

## Context

What pressure forced the decision?

## Decision

What are we doing?

## Consequences

What improves, what gets worse, and what must be monitored or tested?
```
