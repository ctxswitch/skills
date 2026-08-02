---
name: context-drift
description: "Rebuild a repository's CONTEXT.md files from current source, working dependencies-first, and surface where code, docs, and recorded language disagree. Use when context has drifted from the code, or a repo has none. For settling a new design's vocabulary in conversation use grill-me."
---

# Context Drift

Rebuild recorded domain language from what the code does now. Code is evidence; docs and existing context are claims about it.

This skill writes documentation. It does not change source. Code defects it exposes are reported and routed to `engineer` or `diagnose`.

## Guard against the defaults

The default failure mode is treating every difference as a conflict and asking the user what the codebase already answers.

- **Do not ask what the codebase answers.** An ambiguity raised in one module is usually settled by a module not yet read. Nothing becomes a question until the sweep is finished and the entry has been re-tested against everything read since.
- **Different words for different things is not a conflict.** A conflict is one term carrying two meanings, one rule implemented two ways, or recorded language the code no longer supports. Modules that never interact can name things freely.
- **Docs are claims, not evidence.** A README, ADR, or CONTEXT.md states what someone intended. Only code states what happens. Where they differ, both go to the user — the doc is not the tiebreaker.
- **A term is defined by the module that owns it**, not by a caller that uses it or a doc that mentions it.
- **Record domain language, not implementation.** A term belongs in `CONTEXT.md` when a domain expert would recognise it. Struct names, handler names, and package layout do not qualify unless they carry a domain invariant or responsibility.

## 1. Scope the run

Read `CONTEXT-MAP.md` if it exists, otherwise `CONTEXT.md`, then build the internal dependency graph for the scope and order it dependencies-first.

State the scope and the module count before reading anything else. If the graph does not fit in one pass, narrow it with the user first.

## 2. Sweep dependencies-first

A module is read before anything that depends on it. The owner fixes a term's meaning; every later use is measured against that definition.

From the code of each module, establish:

- **Functionality** — the behaviour a caller depends on.
- **Limits** — bounds, quotas, sizes, timeouts, cardinalities, retention.
- **Restrictions** — preconditions, invariants, illegal states, orderings that must hold, authorization points.
- **Terms owned** — the domain concepts this module defines, and what each means here.

Then compare against the module's recorded context and any docs covering it. Three outcomes:

- **Agreement** — nothing to do.
- **Gap** — the code clearly defines a domain term that context does not record, or records nothing at all. Write it.
- **Conflict** — log it to the ledger. Do not ask, do not write.

Divergence introduced over time shows up as two spellings of one concept, or one concept split across two names that both survive. Look for it at every seam where two modules exchange a domain object.

## 3. Close the ledger

Each entry carries the term or rule, the code evidence with `file:line`, the competing doc or context claim, and what is unresolved.

When the sweep completes, re-test every open entry against everything read since it was logged. An entry closes when a later module names the owner, an ADR states the decision, or a second call site disambiguates. Only entries surviving the re-test reach the user.

## 4. Ask what is left

Ask interactively, one decision at a time, each with your recommended answer.

A question carries three things and nothing else:

- what the code does, with `file:line`
- what the docs or context claim
- the decision needed

Rank by blast radius — a term crossing contexts before one local to a module.

The user's answer is the decision. When it contradicts the code, record the decision and report the code as defective; do not edit it.

## 5. Write

Placement follows `CONTEXT-MAP.md`, using the narrowest context that owns the language. Use the formats in the `grill-me` skill: [context-format.md](../grill-me/references/context-format.md) and [adr-format.md](../grill-me/references/adr-format.md).

Write each entry as its decision lands, not in a batch at the end. Offer an ADR only when it is hard to reverse, surprising without context, and the result of a real trade-off.

Report what was written, what the user decided, and every code defect the sweep exposed.
