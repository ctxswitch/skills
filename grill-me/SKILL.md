---
name: grill-me
description: "Interrogate a plan against the project's own domain language and recorded decisions, sharpening terminology and updating CONTEXT.md inline as answers land. Use when the plan's vocabulary or its fit with documented decisions is what needs testing. For correctness under failure, use distributed-systems."
---

# Grill Me

Press on unresolved decisions and their consequences until the design is settled.
Walk down the branches of the design tree that can change the plan, implementation, domain language, or documentation.
For each question, provide your recommended answer.
Ask the questions one at a time, waiting for feedback on each question before continuing.
If a question can be answered by exploring the codebase, explore the codebase instead.
Do not ask a question if the answer is already stated, directly implied by prior answers, or discoverable from local code/docs. If the answer is discoverable, inspect first and ask only to resolve a contradiction or missing decision.
Continue while the next question exposes a real unresolved decision, contradiction, risk, or implementation consequence. When the next question would only restate known tradeoffs or ask for preference without consequence, summarize what is resolved and identify the next concrete action.

## Domain awareness

During codebase exploration, also look for existing documentation:

### File structure

Context files form a hierarchy — one per directory that owns language, each describing only its own level. Decisions are recorded in the same files. See [context-format.md](./references/context-format.md).

```
/
├── CONTEXT.md                    the product
├── CONTEXT-MAP.md                cross-cutting relationships only
└── services/
    ├── CONTEXT.md                the services and what each is for
    └── billing/
        ├── CONTEXT.md            the billing domain
        └── ledger/CONTEXT.md     the ledger's own terms
```

Create files lazily — only when you have something to write.
If no `CONTEXT.md` exists, create one when the first term is resolved.

### Context placement

Before writing or updating any `CONTEXT.md`, decide which level owns the language. **A fact belongs at the shallowest directory where it holds for everything beneath it, and no shallower.**

- Language every area shares goes at the root.
- Language true across one area goes at that area's directory.
- Language local to one package goes at that package.
- A decision spanning areas is written once at their common ancestor, with area-specific responsibilities recorded in each.
- Do not put implementation details in `CONTEXT.md` unless they express a domain-facing invariant or responsibility.

Do not append to an existing file because it exists. Existing context is vocabulary to respect, not necessarily the right level for new language.

## During the session

### Challenge against the glossary

When the user uses a term that conflicts with the existing language in `CONTEXT.md`, call it out immediately.

"Your glossary defines 'cancellation' as X, but you seem to mean Y — which is it?"

### Sharpen fuzzy language

When the user uses vague or overloaded terms, propose a precise canonical term only if the ambiguity could lead to different code, ownership, user behavior, operational behavior, tests, or documentation.

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

Before writing, read the context files from the root down to the target directory, then place the entry by the rule in *Context placement* above. Create that file lazily if it does not exist.

Use the format in [context-format.md](./references/context-format.md).
Don't couple `CONTEXT.md` to implementation details.
Only include terms that are meaningful to domain experts.

An entry is a definition, not a transcript. The discussion that produced the term, the alternatives weighed, and who said what are not part of it.

### Record decisions sparingly

When a decision settles, record it where it constrains — `_Fixed_:` on the term it governs, or the scope's `## Decisions` section when it governs no single term.

Record it only while someone would still reach for the alternative. Name who would propose it and what would make it look right; if you cannot, the outcome already recorded is enough. See [context-format.md](./references/context-format.md).
