---
name: grill-me
description: Grilling session that challenges your plan against the existing domain model, sharpens terminology, and updates the appropriate CONTEXT.md or ADRs inline as decisions crystallise, including routing new domain language to the right bounded context. Use when user wants to stress-test a plan against their project's language and documented decisions.
---

Interview me relentlessly about every aspect of this plan until we reach a shared understanding.
Walk down each branch of the design tree, resolving dependencies between decisions one-by-one.
For each question, provide your recommended answer.
Ask the questions one at a time, waiting for feedback on each question before continuing.
If a question can be answered by exploring the codebase, explore the codebase instead.

## Domain awareness

During codebase exploration, also look for existing documentation:

### File structure

Most repos have a single context:

```
/
├── CONTEXT.md
├── docs/
│   └── adr/
│       ├── 0001-event-sourced-orders.md
│       └── 0002-postgres-for-write-model.md
└── src/
```

If a `CONTEXT-MAP.md` exists at the root, the repo has multiple contexts. The map points to where each one lives:

```
/
├── CONTEXT-MAP.md
├── docs/
│   └── adr/              ← system-wide decisions
├── src/
│   ├── ordering/
│   │   ├── CONTEXT.md
│   │   └── docs/adr/    ← context-specific decisions
│   └── billing/
│       ├── CONTEXT.md
│       └── docs/adr/
```

Create files lazily — only when you have something to write.
If no `CONTEXT.md` exists, create one when the first term is resolved.
If no `docs/adr/` exists, create it when the first ADR is needed.

### Context placement

Before writing or updating any `CONTEXT.md` or ADR, decide where the resolved language belongs.

Read `CONTEXT-MAP.md` first when it exists. Treat the map as the routing table for domain language:

- Use the root or docs context only for product-wide, cross-context language that multiple areas should share.
- Use a context-specific `CONTEXT.md` when the term, invariant, relationship, or workflow mainly belongs to one bounded area.
- If the context-specific file named by `CONTEXT-MAP.md` does not exist, create it lazily when a real term or relationship is resolved for that area.
- If a decision spans multiple contexts, write the shared product term once in the cross-cutting context, then write area-specific responsibilities or invariants in each relevant context.
- Do not put implementation details in `CONTEXT.md` unless they express a domain-facing invariant or responsibility.

Do not append to the existing populated context just because it exists. Existing context is vocabulary to respect, not necessarily the correct destination for new language.

## During the session

### Challenge against the glossary

When the user uses a term that conflicts with the existing language in `CONTEXT.md`, call it out immediately.

"Your glossary defines 'cancellation' as X, but you seem to mean Y — which is it?"

### Sharpen fuzzy language

When the user uses vague or overloaded terms, propose a precise canonical term.

"You're saying 'account' — do you mean the Customer or the User? Those are different things."

### Discuss concrete scenarios

When domain relationships are being discussed, stress-test them with specific scenarios.
Invent scenarios that probe edge cases and force the user to be precise about the boundaries between concepts.

### Cross-reference with code

When the user states how something works, check whether the code agrees.

If you find a contradiction, surface it:

"Your code cancels entire Orders, but you just said partial cancellation is possible — which is right?"

### Update CONTEXT.md inline

When a term, relationship, invariant, or responsibility is resolved, update the appropriate `CONTEXT.md` right there.
Don't batch these up — capture them as they happen.

Before writing:

1. Identify the bounded context using `CONTEXT-MAP.md` when present.
2. Read the existing cross-cutting context and the target context if they exist.
3. Choose the narrowest context that owns the language.
4. Create the target context lazily if it does not exist and the resolved language belongs there.

Use cross-cutting context only for language shared across bounded contexts. Use context-specific files for area-local responsibilities, lifecycle rules, state semantics, API behavior, runtime behavior, or operational ownership.

Use the format in [context-format.md](./references/context-format.md).
Don't couple `CONTEXT.md` to implementation details.
Only include terms that are meaningful to domain experts.

### Offer ADRs sparingly

Only offer to create an ADR when all three are true:

1. **Hard to reverse** — the cost of changing your mind later is meaningful
2. **Surprising without context** — a future reader will wonder "why did they do it this way?"
3. **The result of a real trade-off** — there were genuine alternatives and you picked one for specific reasons

If any of the three is missing, skip the ADR.
Use the format in [adr-format.md](./references/adr-format.md).
