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

Read the context files from the repo root down to the area under discussion before asking anything. They carry the domain language and the decisions already settled.

The `context` skill owns these files — [context-format.md](../context/references/context-format.md) defines the hierarchy, the placement rule, and the entry shape. This skill reads them and writes what a grilling session resolves. A repo whose context is absent or badly drifted is a job for `context` first.

Create files lazily — only when you have something to write.

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

Before writing, read the context files from the root down to the target directory, then place the entry by the rules in [context-format.md](../context/references/context-format.md). Create that file lazily if it does not exist.

When the resolved language describes something not yet built, mark it `_Pending_:` with where the code is expected.

Don't couple `CONTEXT.md` to implementation details.
Only include terms that are meaningful to domain experts.

An entry is a definition, not a transcript. The discussion that produced the term, the alternatives weighed, and who said what are not part of it.

### Record decisions sparingly

When a decision settles, record it where it constrains — `_Fixed_:` on the term it governs, or the scope's `## Decisions` section when it governs no single term.

Record it only while someone would still reach for the alternative. Name who would propose it and what would make it look right; if you cannot, the outcome already recorded is enough. See [context-format.md](../context/references/context-format.md).
